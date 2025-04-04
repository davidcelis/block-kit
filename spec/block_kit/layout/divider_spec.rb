# frozen_string_literal: true

require "spec_helper"
require_relative "../../support/shared_examples/block_id"

RSpec.describe BlockKit::Layout::Divider do
  subject(:divider) { described_class.new }

  it "has a type" do
    expect(described_class::TYPE).to eq("divider")
  end

  it "serializes to JSON" do
    expect(divider.as_json).to eq({type: described_class::TYPE})
  end

  it { is_expected.to be_valid }

  it_behaves_like "a block with a block_id"
end
