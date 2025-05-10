# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Header, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:header) { described_class.new(**attributes) }

  it_behaves_like "a class that yields self on initialize"

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

    it "initializes an empty text if none is provided" do
      header = described_class.new(emoji: false)
      expect(header.text).to be_a(BlockKit::Composition::PlainText)
      expect(header.text.text).to be_nil
      expect(header.text.emoji).to be false
    end
  end

  context "attributes" do
    it_behaves_like "a block with a block_id"
    it_behaves_like "a block that has plain text attributes", :text
    it_behaves_like "a block that has plain text emoji assignment", :text
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(150) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :text, truncate: {maximum: described_class::MAX_LENGTH}
  end
end
