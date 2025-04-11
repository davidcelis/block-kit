# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Channel, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {channel_id: "C12345678"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        channel_id: "C12345678"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          style: {
            bold: true,
            italic: false,
            highlight: true
          }
        )
      end

      it "serializes to JSON with all attributes" do
        expect(element.as_json).to eq({
          type: described_class.type.to_s,
          channel_id: "C12345678",
          style: {
            bold: true,
            italic: false,
            highlight: true
          }
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:channel_id).with_type(:string) }
    it { is_expected.to have_attribute(:style).with_type(:block_kit_rich_text_element_mention_style) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:channel_id) }
  end
end
