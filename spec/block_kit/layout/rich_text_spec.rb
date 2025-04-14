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

  describe "#list" do
    let(:args) { {} }
    subject { block.list(**args) }

    it "adds a RichText::List to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Layout::RichText::List)
    end

    it "yields the list" do
      expect { |b| block.list(**args, &b) }.to yield_with_args(BlockKit::Layout::RichText::List)
    end

    context "with optional args" do
      let(:args) do
        {
          style: :unordered,
          elements: [
            {type: "rich_text_section", elements: [{type: "text", text: "Item 1"}]},
            {type: "rich_text_section", elements: [{type: "text", text: "Item 2"}]}
          ],
          indent: 1,
          offset: 2,
          border: 3
        }
      end

      it "creates a list with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last).to be_a(BlockKit::Layout::RichText::List)
        expect(block.elements.last.style).to eq("unordered")
        expect(block.elements.last.elements.size).to eq(2)
        expect(block.elements.last.elements.first.elements.first.text).to eq("Item 1")
        expect(block.elements.last.elements.last.elements.first.text).to eq("Item 2")
        expect(block.elements.last.indent).to eq(1)
        expect(block.elements.last.offset).to eq(2)
        expect(block.elements.last.border).to be(3)
      end
    end
  end

  describe "#preformatted" do
    let(:args) { {} }
    subject { block.preformatted(**args) }

    it "adds a RichText::Preformatted to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Layout::RichText::Preformatted)
    end

    it "yields the preformatted block" do
      expect { |b| block.preformatted(**args, &b) }.to yield_with_args(BlockKit::Layout::RichText::Preformatted)
    end

    context "with optional args" do
      let(:args) do
        {
          elements: [
            {type: "text", text: "Item 1"},
            {type: "text", text: "Item 2"}
          ],
          border: 3
        }
      end

      it "creates a preformatted rich text block with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.elements.size).to eq(2)
        expect(block.elements.last.elements.first.text).to eq("Item 1")
        expect(block.elements.last.elements.last.text).to eq("Item 2")
        expect(block.elements.last.border).to be(3)
      end
    end
  end

  describe "#quote" do
    let(:args) { {} }
    subject { block.quote(**args) }

    it "adds a RichText::Quote to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Layout::RichText::Quote)
    end

    it "yields the quote block" do
      expect { |b| block.quote(**args, &b) }.to yield_with_args(BlockKit::Layout::RichText::Quote)
    end

    context "with optional args" do
      let(:args) do
        {
          elements: [
            {type: "text", text: "Item 1"},
            {type: "text", text: "Item 2"}
          ],
          border: 3
        }
      end

      it "creates a rich text quote block with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.elements.size).to eq(2)
        expect(block.elements.last.elements.first.text).to eq("Item 1")
        expect(block.elements.last.elements.last.text).to eq("Item 2")
        expect(block.elements.last.border).to be(3)
      end
    end
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
