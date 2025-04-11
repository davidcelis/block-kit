# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Actions, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Elements::Button.new(text: "Button", value: "button"),
        BlockKit::Elements::StaticSelect.new(
          placeholder: "Select an option",
          options: [
            BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
            BlockKit::Composition::Option.new(text: "Option 2", value: "option_2")
          ]
        ),
        BlockKit::Elements::TimePicker.new(placeholder: "Select a time", initial_time: "12:00")
      ]
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [
          {type: "button", text: {type: "plain_text", text: "Button"}, value: "button"},
          {type: "static_select", placeholder: {type: "plain_text", text: "Select an option"}, options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ]},
          {type: "timepicker", placeholder: {type: "plain_text", text: "Select a time"}, initial_time: "12:00"}
        ]
      })
    end
  end

  context "attributes" do
    it do
      is_expected.to have_attribute(:elements).with_type(:array).containing(
        :block_kit_button,
        :block_kit_channels_select,
        :block_kit_checkboxes,
        :block_kit_conversations_select,
        :block_kit_datepicker,
        :block_kit_datetimepicker,
        :block_kit_external_select,
        :block_kit_multi_channels_select,
        :block_kit_multi_conversations_select,
        :block_kit_multi_external_select,
        :block_kit_multi_static_select,
        :block_kit_multi_users_select,
        :block_kit_overflow,
        :block_kit_radio_buttons,
        :block_kit_rich_text_input,
        :block_kit_static_select,
        :block_kit_timepicker,
        :block_kit_users_select,
        :block_kit_workflow_button
      )
    end

    it_behaves_like "a block with a block_id"

    it "does not allow unsupported elements" do
      expect {
        block.elements << BlockKit::Elements::PlainTextInput.new
      }.not_to change {
        block.elements.size
      }
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:elements) }

    it "validates elements" do
      block.elements[1].options << BlockKit::Composition::Option.new(text: "", value: "option_3")

      expect(block).not_to be_valid
      expect(block.errors["elements[1]"]).to include("is invalid: options[2].text can't be blank")
    end

    it "validates the number of elements" do
      block.elements = Array.new(26) { BlockKit::Elements::Button.new(text: "Button", value: "button") }

      expect(block).not_to be_valid
      expect(block.errors[:elements]).to include("is too long (maximum is 25 elements)")
    end
  end
end
