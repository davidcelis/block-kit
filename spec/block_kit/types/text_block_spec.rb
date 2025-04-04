# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::TextBlock do
  subject(:type) { described_class.new }

  it "has a type" do
    expect(subject.type).to eq(:text_block)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is a PlainText block" do
      let(:value) { BlockKit::Composition::PlainText.new(text: "Hello, world!") }

      it { is_expected.to eq(value) }
    end

    context "when the value is a Mrkdwn block" do
      let(:value) { BlockKit::Composition::Mrkdwn.new(text: "Hello, world!") }

      it { is_expected.to eq(value) }
    end

    context "when the value is nil" do
      let(:value) { nil }

      it "returns an empty Mrkdwn block" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to be_nil
        expect(result.verbatim).to be_nil
      end
    end

    context "when the value is a string" do
      let(:value) { "Hello, world!" }

      it "returns a Mrkdwn block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to eq("Hello, world!")
        expect(result.verbatim).to be_nil
      end
    end

    context "when the value is a Hash" do
      let(:value) { {text: "Hello, world!"} }

      it "returns a Mrkdwn block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to eq("Hello, world!")
        expect(result.verbatim).to be_nil
      end

      context "when the value has a `verbatim` key" do
        let(:value) { super().merge(verbatim: false) }

        it "returns a Mrkdwn block" do
          expect(result).to be_a(BlockKit::Composition::Mrkdwn)
          expect(result.text).to eq("Hello, world!")
          expect(result.verbatim).to be false
        end
      end

      context "when the value has an `emoji` key" do
        let(:value) { super().merge(emoji: false) }

        it "returns a PlainText block" do
          expect(result).to be_a(BlockKit::Composition::PlainText)
          expect(result.text).to eq("Hello, world!")
          expect(result.emoji).to be false
        end
      end

      context "when the value has both `verbatim` and `emoji` keys" do
        let(:value) { super().merge(verbatim: false, emoji: true) }

        it "raises an ArgumentError" do
          expect { result }.to raise_error(ArgumentError, /Cannot cast/)
        end
      end
    end
  end
end
