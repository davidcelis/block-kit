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

  describe "#section" do
    let(:args) { {} }
    subject { block.section(**args) }

    it "adds a RichText::Section to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Layout::RichText::Section)
    end

    it "yields the section block" do
      expect { |b| block.section(**args, &b) }.to yield_with_args(BlockKit::Layout::RichText::Section)
    end

    context "with optional args" do
      let(:args) do
        {
          elements: [
            {type: "text", text: "Item 1"},
            {type: "text", text: "Item 2"}
          ]
        }
      end

      it "creates a rich text section block with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.elements.size).to eq(2)
        expect(block.elements.last.elements.first.text).to eq("Item 1")
        expect(block.elements.last.elements.last.text).to eq("Item 2")
      end
    end
  end

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
end
