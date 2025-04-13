# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Option do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_option)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is an Option block" do
      let(:value) { BlockKit::Composition::Option.new(text: "Option 1", value: "value_1") }

      it { is_expected.to eq(value) }
    end

    context "when the value is an OverflowOption block" do
      let(:value) { BlockKit::Composition::OverflowOption.new(text: "Option 1", value: "value_1", url: "https://example.com") }

      it "returns an Option block with the OverflowOption's text and value" do
        expect(result).to be_a(BlockKit::Composition::Option)
        expect(result.text.text).to eq("Option 1")
        expect(result.value).to eq("value_1")
        expect(result).not_to respond_to(:url)
      end
    end

    context "when the value is a Hash" do
      let(:value) { {text: "Option 1", value: "value_1"} }

      it "returns an Option block" do
        expect(result).to be_a(BlockKit::Composition::Option)
        expect(result.text.text).to eq("Option 1")
        expect(result.value).to eq("value_1")
      end
    end

    context "when the value is nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end
  end
end
