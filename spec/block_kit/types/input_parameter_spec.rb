# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::InputParameter do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_input_parameter)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is an InputParameter block" do
      let(:value) { BlockKit::Composition::InputParameter.new(name: "greeting", value: "Hello, world!") }

      it { is_expected.to eq(value) }
    end

    context "when the value is a Hash" do
      let(:value) { {name: "greeting", value: "Hello, world!"} }

      it "returns an InputParameter block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::InputParameter)
        expect(result.name).to eq("greeting")
        expect(result.value).to eq("Hello, world!")
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
