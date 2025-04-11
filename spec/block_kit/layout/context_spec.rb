# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Context, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Composition::PlainText.new(text: "Hello", emoji: false),
        BlockKit::Elements::Image.new(image_url: "https://example.com/image.png", alt_text: "An image"),
        BlockKit::Composition::Mrkdwn.new(text: "This is a text element", verbatim: true)
      ]
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [
          {type: "plain_text", text: "Hello", emoji: false},
          {type: "image", image_url: "https://example.com/image.png", alt_text: "An image"},
          {type: "mrkdwn", text: "This is a text element", verbatim: true}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:elements).with_type(:array).containing(:block_kit_image, :block_kit_mrkdwn, :block_kit_plain_text) }

    it_behaves_like "a block with a block_id"

    it "does not allow unsupported elements" do
      expect {
        block.elements << BlockKit::Composition::Option.new
      }.not_to change {
        block.elements.size
      }
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:elements) }

    it "validates elements" do
      block.elements[1].image_url = ""

      expect(block).not_to be_valid
      expect(block.errors["elements[1]"]).to include("is invalid: image_url can't be blank")
    end
  end
end
