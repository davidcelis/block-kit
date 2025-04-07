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
      let(:value) { BlockKit::Composition::Option.new(text: "Hello, world!", value: "hello_world") }

      it { is_expected.to eq(value) }
    end

    context "when the value is a Hash" do
      let(:value) { {text: "Hello, world!", value: "hello_world"} }

      it "returns an Option block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::Option)
        expect(result.text.text).to eq("Hello, world!")
        expect(result.value).to eq("hello_world")
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
