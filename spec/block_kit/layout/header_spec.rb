# frozen_string_literal: true

require "spec_helper"
require_relative "../../support/shared_examples/block_id"

RSpec.describe BlockKit::Layout::Header do
  subject(:header) { described_class.new(text: "Hello, world!") }

  it "has a type" do
    expect(described_class::TYPE).to eq("header")
  end

  it "serializes to JSON" do
    expect(header.as_json).to eq({
      type: described_class::TYPE,
      text: {type: "plain_text", text: "Hello, world!"}
    })
  end

  it { is_expected.to be_valid }

  it "validates the length of text" do
    expect(header).to be_valid

    header.text = "a" * 151
    expect(header).not_to be_valid
    expect(header.errors[:text]).to include("is too long (maximum is 150 characters)")

    header.text = nil
    expect(header).not_to be_valid
    expect(header.errors[:text]).to include("can't be blank")
  end

  it_behaves_like "a block with a block_id"
end
