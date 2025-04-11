# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Section, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Layout::RichText::Elements::Text.new(text: "Hello, "),
        BlockKit::Layout::RichText::Elements::User.new(user_id: "U12345678", style: {bold: true}),
        BlockKit::Layout::RichText::Elements::Text.new(text: "!")
      ]
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
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:elements).with_type(:array).containing(*BlockKit::Layout::RichText::Elements.all.map { |t| :"block_kit_#{t.type}" }) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:elements) }

    it "validates associated elements" do
      block.elements << BlockKit::Layout::RichText::Elements::Text.new

      expect(block).not_to be_valid
      expect(block.errors["elements[3]"]).to include("is invalid: text can't be blank")
    end
  end
end
