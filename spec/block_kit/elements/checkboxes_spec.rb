# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::Checkboxes, type: :model do
  subject(:checkboxes) { described_class.new(attributes) }
  let(:attributes) do
    {
      options: [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2"}
      ]
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(checkboxes.as_json).to eq({
        type: described_class::TYPE,
        options: [
          {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
          {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
        ],
        initial_options: []
      })
    end

    context "with all attributes" do
      let(:attributes) do
        {
          options: [
            {text: "Option 1", value: "option_1"},
            {text: "Option 2", value: "option_2", initial: true}
          ],
          confirm: {
            title: "Dialog Title",
            text: "Dialog Text",
            confirm: "Yes",
            deny: "No"
          },
          focus_on_load: false
        }
      end

      it "serializes to JSON" do
        expect(checkboxes.as_json).to eq({
          type: described_class::TYPE,
          options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ],
          initial_options: [
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ],
          confirm: checkboxes.confirm.as_json,
          focus_on_load: false
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:options).with_type(:array, :block_kit_option) }
    it { is_expected.to have_attribute(:confirm).with_type(:block_kit_confirmation_dialog) }
    it { is_expected.to have_attribute(:focus_on_load).with_type(:boolean) }

    it_behaves_like "a block with an action_id"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates that options are present" do
      checkboxes.options = nil
      expect(checkboxes).not_to be_valid
      expect(checkboxes.errors[:options]).to include("can't be blank")

      checkboxes.options = []
      expect(checkboxes).not_to be_valid
      expect(checkboxes.errors[:options]).to include("can't be blank")
    end

    it "validates that there can be at most 10 options" do
      checkboxes.options = Array.new(11) { {text: "Option", value: "value"} }
      expect(checkboxes).not_to be_valid
      expect(checkboxes.errors[:options]).to include("is too long (maximum is 10 options)")
    end

    it "validates the associated options themselves" do
      checkboxes.options = [{text: "Option 1", value: ""}]
      expect(checkboxes).not_to be_valid
      expect(checkboxes.errors["options[0]"]).to include("is invalid: value can't be blank")
    end

    it "validates the associated confirmation dialog" do
      checkboxes.confirm = BlockKit::Composition::ConfirmationDialog.new(
        title: "",
        text: "Dialog Text",
        confirm: "Yes",
        deny: "No"
      )

      expect(checkboxes).not_to be_valid
      expect(checkboxes.errors[:confirm]).to include("is invalid: title can't be blank")
    end
  end
end
