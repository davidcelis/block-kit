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

  describe "#text" do
    it "casts a string to a PlainText block" do
      header.text = "Header text"
      expect(header.text).to be_a(BlockKit::Composition::PlainText)
      expect(header.text.text).to eq("Header text")
      expect(header.text.emoji).to be_nil
    end

    it "accepts a PlainText block" do
      header.text = BlockKit::Composition::PlainText.new(text: "Header text", emoji: false)
      expect(header.text).to be_a(BlockKit::Composition::PlainText)
      expect(header.text.text).to eq("Header text")
      expect(header.text.emoji).to be(false)
    end

    it "casts a Mrkdwn block to a PlainText block" do
      header.text = BlockKit::Composition::Mrkdwn.new(text: "Header text", verbatim: true)
      expect(header.text).to be_a(BlockKit::Composition::PlainText)
      expect(header.text.text).to eq("Header text")
      expect(header.text.emoji).to be_nil
      expect(header.text).not_to respond_to(:verbatim)
    end

    it "casts a Hash to a PlainText block" do
      header.text = {text: "Header text", emoji: false}
      expect(header.text).to be_a(BlockKit::Composition::PlainText)
      expect(header.text.text).to eq("Header text")
      expect(header.text.emoji).to be(false)
    end
  end

  context "validations" do
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
  end

  it_behaves_like "a block with a block_id"
end
