# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::OverflowOption do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_overflow_option)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is an OverflowOption block" do
      let(:value) { BlockKit::Composition::OverflowOption.new(text: "Option 1", value: "value_1", url: "https://example.com") }

      it { is_expected.to eq(value) }
    end

    context "when the value is an OverflowOption block" do
      let(:value) { BlockKit::Composition::Option.new(text: "Option 1", value: "value_1") }

      it "returns an OverflowOption block with the Option's text and value" do
        expect(result).to be_a(BlockKit::Composition::OverflowOption)
        expect(result.text.text).to eq("Option 1")
        expect(result.value).to eq("value_1")
        expect(result.url).to be_nil
      end
    end

    context "when the value is a Hash" do
      let(:value) { {text: "Option 1", value: "value_1", url: "https://example.com"} }

      it "returns an Option block" do
        expect(result).to be_a(BlockKit::Composition::OverflowOption)
        expect(result.text.text).to eq("Option 1")
        expect(result.value).to eq("value_1")
        expect(result.url).to eq("https://example.com")
      end
    end

    context "when the value is nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end
  end
end
