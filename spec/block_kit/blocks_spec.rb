# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Blocks do
  subject(:blocks) { described_class.new }

  it "yields self on initialize" do
    described_class.new do |blocks|
      expect(blocks).to be_a(described_class)
    end
  end

  describe "#divider" do
    it "appends a divider block" do
      blocks.divider

      expect(blocks.as_json).to eq([{type: "divider"}])
    end

    it "accepts a block_id" do
      blocks.divider(block_id: "block_id")
      expect(blocks.as_json).to eq([{type: "divider", block_id: "block_id"}])
    end
  end
end
