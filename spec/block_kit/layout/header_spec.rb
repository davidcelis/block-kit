# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Header, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:header) { described_class.new(**attributes) }

  it "has a type" do
    expect(described_class.type.to_s).to eq("header")
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(header.as_json).to eq({
        type: described_class.type.to_s,
        text: {type: "plain_text", text: "Hello, world!"}
      })
    end
  end

  describe "#initialize" do
    it "allows setting emoji on the text" do
      header = described_class.new(text: "Hello, world!", emoji: false)
      expect(header.text.emoji).to be false
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:block_kit_plain_text) }

    it_behaves_like "a block with a block_id"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(150) }
  end
end
