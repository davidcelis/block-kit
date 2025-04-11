# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Text, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {text: "Hello, world!"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        text: "Hello, world!"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          style: BlockKit::Layout::RichText::Elements::TextStyle.new(bold: true, italic: false, code: nil)
        )
      end

      it "includes all attributes" do
        expect(element.as_json).to eq({
          type: described_class.type.to_s,
          text: "Hello, world!",
          style: {bold: true, italic: false}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:string) }
    it { is_expected.to have_attribute(:style).with_type(:block_kit_rich_text_element_text_style) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
  end
end
