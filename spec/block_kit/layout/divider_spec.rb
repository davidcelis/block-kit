# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Divider, type: :model do
  subject(:divider) { described_class.new }

  it "has a type" do
    expect(described_class::TYPE).to eq("divider")
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(divider.as_json).to eq({type: described_class::TYPE})
    end
  end

  context "validations" do
    it { is_expected.to be_valid }
  end

  it_behaves_like "a block with a block_id"
end
