# frozen_string_literal: true

require "spec_helper"

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

  context "with a block_id" do
    let(:header) { described_class.new(text: "Hello, world!", block_id: "block_id") }

    it "serializes to JSON with block_id" do
      expect(header.as_json).to eq({
        type: described_class::TYPE,
        text: {type: "plain_text", text: "Hello, world!"},
        block_id: "block_id"
      })
    end

    it "casts block_id to string" do
      header.block_id = 123
      expect(header.block_id).to eq("123")
    end

    it "validates the length of block_id" do
      expect(header).to be_valid

      header.block_id = "a" * 256
      expect(header).not_to be_valid
      expect(header.errors[:block_id]).to include("is too long (maximum is 255 characters)")

      header.block_id = nil
      expect(header).to be_valid
    end
  end
end
