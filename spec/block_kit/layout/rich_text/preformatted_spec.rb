# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Preformatted, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Layout::RichText::Elements::Text.new(text: "Hello, "),
        BlockKit::Layout::RichText::Elements::User.new(user_id: "U12345678", style: {bold: true}),
        BlockKit::Layout::RichText::Elements::Text.new(text: "!")
      ],
      border: 0
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [
          {type: "text", text: "Hello, "},
          {type: "user", user_id: "U12345678", style: {bold: true}},
          {type: "text", text: "!"}
        ],
        border: 0
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:elements).with_type(:array).containing(*BlockKit::Layout::RichText::Elements.all.map { |t| :"block_kit_#{t.type}" }) }
    it { is_expected.to have_attribute(:border).with_type(:integer) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:elements) }
    it { is_expected.to allow_value(1).for(:border) }
    it { is_expected.to allow_value(0).for(:border) }
    it { is_expected.not_to allow_value(-1).for(:border) }
    it { is_expected.to allow_value(nil).for(:border) }

    it "validates associated elements" do
      block.elements << BlockKit::Layout::RichText::Elements::Text.new

      expect(block).not_to be_valid
      expect(block.errors["elements[3]"]).to include("is invalid: text can't be blank")
    end
  end
end
