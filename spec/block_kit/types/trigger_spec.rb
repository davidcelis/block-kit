# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Trigger do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_trigger)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is an Trigger block" do
      let(:value) { BlockKit::Composition::Trigger.new(url: "https://example.com") }

      it { is_expected.to eq(value) }
    end

    context "when the value is a Hash" do
      let(:value) { {url: "https://example.com", customizable_input_parameters: [{name: "greeting", value: "Hello, world!"}]} }

      it "returns an Trigger block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::Trigger)
        expect(result.url).to eq("https://example.com")
        expect(result.customizable_input_parameters).to be_a(Array)
        expect(result.customizable_input_parameters.size).to eq(1)

        input_parameter = result.customizable_input_parameters.first
        expect(input_parameter).to be_a(BlockKit::Composition::InputParameter)
        expect(input_parameter.name).to eq("greeting")
        expect(input_parameter.value).to eq("Hello, world!")
      end
    end

    context "for other values" do
      let(:value) { "Hello, world!" }

      it "returns nil" do
        expect(result).to be_nil
      end
    end
  end
end
