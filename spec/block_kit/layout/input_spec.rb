# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Input, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      label: "Name",
      element: BlockKit::Elements::PlainTextInput.new(placeholder: "Enter your name")
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        label: {type: "plain_text", text: "Name"},
        element: {
          type: "plain_text_input",
          placeholder: {type: "plain_text", text: "Enter your name"}
        }
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(hint: "This is a hint", optional: true) }

      it "serializes to JSON" do
        expect(block.as_json).to eq({
          type: described_class.type.to_s,
          label: {type: "plain_text", text: "Name"},
          element: {
            type: "plain_text_input",
            placeholder: {type: "plain_text", text: "Enter your name"}
          },
          hint: {type: "plain_text", text: "This is a hint"},
          optional: true
        })
      end
    end
  end

  context "attributes" do
    it do
      is_expected.to have_attribute(:element).with_type(:block_kit_block).containing(
        :block_kit_channels_select,
        :block_kit_checkboxes,
        :block_kit_conversations_select,
        :block_kit_datepicker,
        :block_kit_datetimepicker,
        :block_kit_email_text_input,
        :block_kit_external_select,
        :block_kit_file_input,
        :block_kit_multi_channels_select,
        :block_kit_multi_conversations_select,
        :block_kit_multi_external_select,
        :block_kit_multi_static_select,
        :block_kit_multi_users_select,
        :block_kit_number_input,
        :block_kit_plain_text_input,
        :block_kit_radio_buttons,
        :block_kit_rich_text_input,
        :block_kit_static_select,
        :block_kit_timepicker,
        :block_kit_users_select,
        :block_kit_url_text_input
      )
    end

    it_behaves_like "a block with a block_id"

    it "does not allow unsupported elements" do
      block.element = BlockKit::Elements::Button.new

      expect(block.element).to be_nil
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:hint).allow_nil }
    it { is_expected.to validate_length_of(:hint).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:element) }

    it "validates the associated element" do
      block.element.min_length = 10
      block.element.max_length = 5

      expect(block).not_to be_valid
      expect(block.errors[:element]).to include("is invalid: min_length must be less than or equal to max_length")
    end
  end
end
