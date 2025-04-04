# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::PlainText do
  subject(:plain_text_block) { described_class.new }

  it "has a type" do
    expect(described_class::TYPE).to eq("plain_text")
  end

  it "serializes to JSON" do
    expect(plain_text_block.as_json).to eq({type: described_class::TYPE})
  end

  it { is_expected.to be_valid }

  context "with all attributes" do
    let(:plain_text_block) { described_class.new(text: "Hello, world!", emoji: false) }

    it "serializes to JSON" do
      expect(plain_text_block.as_json).to eq({
        type: described_class::TYPE,
        text: "Hello, world!",
        emoji: false
      })
    end
  end
end
