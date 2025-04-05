# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Mrkdwn do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_mrkdwn)
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

      context "when the value has a `emoji` key" do
        let(:value) { super().merge(emoji: false) }

        it "ignorse unknown attributes" do
          expect(result).to be_a(BlockKit::Composition::Mrkdwn)
          expect(result.text).to eq("Hello, world!")
          expect(result.verbatim).to be_nil
        end
      end
    end

    context "when the value is some other type" do
      let(:value) { 123 }

      it "falls back to ActiveModel's default casting behavior" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to eq("123")
        expect(result.verbatim).to be_nil
      end
    end
  end
end
