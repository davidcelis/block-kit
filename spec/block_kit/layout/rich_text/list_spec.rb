# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::List, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      style: :ordered,
      elements: [
        BlockKit::Layout::RichText::Section.new(
          elements: [
            BlockKit::Layout::RichText::Elements::Text.new(text: "Hello, "),
            BlockKit::Layout::RichText::Elements::User.new(user_id: "U12345678")
          ]
        ),
        BlockKit::Layout::RichText::Section.new(
          elements: [
            BlockKit::Layout::RichText::Elements::Text.new(text: "Another list item", style: {bold: true})
          ]
        )
      ]
    }
  end

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
    as: :section,
    type: BlockKit::Layout::RichText::Section,
    actual_fields: {elements: [BlockKit::Layout::RichText::Elements::Text.new(text: "Item 1")]}

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        style: "ordered",
        elements: [
          {type: "rich_text_section", elements: [{type: "text", text: "Hello, "}, {type: "user", user_id: "U12345678"}]},
          {type: "rich_text_section", elements: [{type: "text", text: "Another list item", style: {bold: true}}]}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:elements).with_type(:array).containing(:block_kit_rich_text_section) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:style) }
    it { is_expected.to validate_inclusion_of(:style).in_array(described_class::VALID_STYLES) }
    it { is_expected.to validate_presence_of(:elements) }

    %i[indent offset border].each do |attr|
      it { is_expected.to allow_value(1).for(attr) }
      it { is_expected.to allow_value(0).for(attr) }
      it { is_expected.not_to allow_value(-1).for(attr) }
      it { is_expected.to allow_value(nil).for(attr) }
    end

    it "validates associated sections" do
      block.elements << BlockKit::Layout::RichText::Section.new

      expect(block).not_to be_valid
      expect(block.errors["elements[2]"]).to include("is invalid: elements can't be blank")
    end
  end

  context "fixers" do
    it "fixes associated elements" do
      element_1 = BlockKit::Layout::RichText::Elements::Date.new(timestamp: 1234567890, format: "{date_long_pretty}", url: "", fallback: "")
      element_2 = BlockKit::Layout::RichText::Elements::Emoji.new(name: "smile", unicode: "1F600")
      element_3 = BlockKit::Layout::RichText::Elements::Emoji.new(name: "hotdog", unicode: "")
      section = BlockKit::Layout::RichText::Section.new(elements: [element_1, element_2, element_3])

      subject.elements = [section]

      expect {
        subject.fix_validation_errors
      }.to change {
        element_1.url
      }.from("").to(nil).and change {
        element_1.fallback
      }.from("").to(nil).and change {
        element_3.unicode
      }.from("").to(nil)
    end
  end
end
