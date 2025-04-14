# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Layout::RichText::Section.new(
          elements: [
            {type: "text", text: "Hello, "},
            {type: "user", user_id: "U12345678", style: {bold: true}}
          ]
        ),
        BlockKit::Layout::RichText::List.new(
          style: :ordered,
          elements: [
            {type: "rich_text_section", elements: [{type: "text", text: "Item 1"}]},
            BlockKit::Layout::RichText::Section.new(elements: [{type: "text", text: "Item 2"}])
          ]
        ),
        BlockKit::Layout::RichText::Preformatted.new(elements: [{type: "text", text: "Preformatted text"}]),
        BlockKit::Layout::RichText::Quote.new(
          elements: [
            {type: "text", text: "We saw it in "},
            {type: "channel", channel_id: "C12345678", style: {bold: true}}
          ]
        )
      ]
    }
  end

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
    as: :list,
    type: BlockKit::Layout::RichText::List,
    actual_fields: {elements: [BlockKit::Layout::RichText::Section.new]}

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
    as: :preformatted,
    type: BlockKit::Layout::RichText::Preformatted,
    actual_fields: {elements: [{type: "text", text: "Some text"}]},
    expected_fields: {elements: [BlockKit::Layout::RichText::Elements::Text.new(text: "Some text")]}

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
    as: :quote,
    type: BlockKit::Layout::RichText::Quote,
    actual_fields: {elements: [{type: "text", text: "Some text"}]},
    expected_fields: {elements: [BlockKit::Layout::RichText::Elements::Text.new(text: "Some text")]}

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
    as: :section,
    type: BlockKit::Layout::RichText::Section,
    actual_fields: {elements: [{type: "text", text: "Some text"}]},
    expected_fields: {elements: [BlockKit::Layout::RichText::Elements::Text.new(text: "Some text")]}

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [
          {type: "rich_text_section", elements: [{type: "text", text: "Hello, "}, {type: "user", user_id: "U12345678", style: {bold: true}}]},
          {type: "rich_text_list", style: "ordered", elements: [{type: "rich_text_section", elements: [{type: "text", text: "Item 1"}]}, {type: "rich_text_section", elements: [{type: "text", text: "Item 2"}]}]},
          {type: "rich_text_preformatted", elements: [{type: "text", text: "Preformatted text"}]},
          {type: "rich_text_quote", elements: [{type: "text", text: "We saw it in "}, {type: "channel", channel_id: "C12345678", style: {bold: true}}]}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:elements).with_type(:array).containing(:block_kit_rich_text_list, :block_kit_rich_text_section, :block_kit_rich_text_preformatted, :block_kit_rich_text_quote) }

    it_behaves_like "a block with a block_id"
  end

  context "validations" do
    it { is_expected.to be_valid }
  end
end
