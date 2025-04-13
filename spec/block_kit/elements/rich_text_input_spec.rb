# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::RichTextInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_value: {
            type: "rich_text",
            elements: [
              BlockKit::Layout::RichText::Section.new(
                elements: [
                  {type: "text", text: "Hello, "},
                  {type: "user", user_id: "U12345678", style: {bold: true}}
                ]
              )
            ]
          }
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class.type.to_s,
          initial_value: {
            type: "rich_text",
            elements: [
              {type: "rich_text_section", elements: [{type: "text", text: "Hello, "}, {type: "user", user_id: "U12345678", style: {bold: true}}]}
            ]
          }
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_value).with_type(:block_kit_rich_text) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that is dispatchable"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_value).allow_nil }

    it "validates initial_value" do
      expect(input).to be_valid

      input.initial_value = BlockKit::Layout::RichText.new(
        elements: [BlockKit::Layout::RichText::Section.new]
      )
      expect(input).not_to be_valid
      expect(input.errors[:initial_value]).to include("is invalid: elements[0].elements can't be blank")
    end
  end
end
