# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Divider do
  subject(:divider) { described_class.new }

  it "has a type" do
    expect(described_class::TYPE).to eq("divider")
  end

  it "serializes to JSON" do
    expect(divider.as_json).to eq({type: described_class::TYPE})
  end

  it { is_expected.to be_valid }

  context "with a block_id" do
    let(:divider) { described_class.new(block_id: block_id) }
    let(:block_id) { "block_id" }

    it "serializes to JSON with block_id" do
      expect(divider.as_json).to eq({type: described_class::TYPE, block_id: block_id})
    end

    it "casts block_id to string" do
      divider.block_id = 123
      expect(divider.block_id).to eq("123")
    end

    it "validates the length of block_id" do
      expect(divider).to be_valid

      divider.block_id = "a" * 256
      expect(divider).not_to be_valid
      expect(divider.errors[:block_id]).to include("is too long (maximum is 255 characters)")
    end
  end
end
