# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Link, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) do
    {
      url: "https://example.com",
      text: "Example link"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        url: "https://example.com",
        text: "Example link"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          unsafe: false,
          style: BlockKit::Layout::RichText::Elements::TextStyle.new(bold: true, italic: false)
        )
      end

      it "includes all attributes" do
        expect(element.as_json).to eq({
          type: described_class.type.to_s,
          url: "https://example.com",
          text: "Example link",
          unsafe: false,
          style: {bold: true, italic: false}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:url).with_type(:string) }
    it { is_expected.to have_attribute(:text).with_type(:string) }
    it { is_expected.to have_attribute(:unsafe).with_type(:boolean) }
    it { is_expected.to have_attribute(:style).with_type(:block_kit_rich_text_element_text_style) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:text) }

    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.to allow_value("anything://is.fine/").for(:url) }
    it { is_expected.not_to allow_value("invalid_url").for(:url).with_message("is not a valid URI") }
  end
end
