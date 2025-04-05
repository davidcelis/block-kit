# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::MrkdwnBlock do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:mrkdwn_block)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is a Mrkdwn block" do
      let(:value) { BlockKit::Composition::Mrkdwn.new(text: "Hello, world!", verbatim: true) }

      it { is_expected.to eq(value) }
    end

    context "when the value is a PlainText block" do
      let(:value) { BlockKit::Composition::PlainText.new(text: "Hello, world!", emoji: true) }

      it "casts to a Mrkdwn block with default attributes" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to eq("Hello, world!")
        expect(result.verbatim).to be_nil
      end
    end

    context "when the value is nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
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

      context "when the value has an `verbatim` key" do
        let(:value) { super().merge(verbatim: false) }

        it "passes it through to the PlainText block" do
          expect(result).to be_a(BlockKit::Composition::Mrkdwn)
          expect(result.text).to eq("Hello, world!")
          expect(result.verbatim).to be false
        end
      end

      context "when the value has a `emoji` key" do
        let(:value) { super().merge(emoji: false) }

        it "ignorse unknown attributes" do
          expect(result).to be_a(BlockKit::Composition::Mrkdwn)
          expect(result.text).to eq("Hello, world!")
          expect(result.verbatim).to be_nil
        end
      end
    end
  end
end
