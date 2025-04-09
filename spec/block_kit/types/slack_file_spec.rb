# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::SlackFile do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_slack_file)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is a SlackFile block" do
      let(:value) { BlockKit::Composition::SlackFile.new(id: "F12345678") }

      it { is_expected.to eq(value) }
    end

    context "when the value is a Hash" do
      let(:value) { {id: "F12345678"} }

      it "returns an Option block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::SlackFile)
        expect(result.id).to eq("F12345678")
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
