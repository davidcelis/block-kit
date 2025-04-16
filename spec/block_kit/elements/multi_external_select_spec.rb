# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::MultiExternalSelect, type: :model do
  subject(:multi_external_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  it_behaves_like "a block that has a DSL method",
    attribute: :initial_options,
    as: :initial_option,
    type: BlockKit::Composition::Option,
    actual_fields: {text: "New Option", value: "new", description: "Description", emoji: false},
    expected_fields: {
      text: BlockKit::Composition::PlainText.new(text: "New Option", emoji: false),
      value: "new",
      description: BlockKit::Composition::PlainText.new(text: "Description", emoji: false)
    },
    required_fields: [:text, :value],
    yields: false

  describe "#as_json" do
    it "serializes to JSON" do
      expect(multi_external_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_options: [
            {text: "Option 1", value: "option_1"},
            {text: "Option 2", value: "option_2"}
          ]
        )
      end

      it "serializes to JSON" do
        expect(multi_external_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ]
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_options).with_type(:array).containing(:block_kit_option) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
    it_behaves_like "an external select"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates the associated initial_options" do
      multi_external_select.initial_options = [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2"},
        {text: "Option 3", value: "option_3"}
      ]
      expect(multi_external_select).to be_valid

      multi_external_select.initial_options[1].value = ""
      expect(multi_external_select).not_to be_valid
      expect(multi_external_select.errors["initial_options[1]"]).to include("is invalid: value can't be blank")
    end
  end

  context "fixers" do
    it "fixes the associated initial_options" do
      multi_external_select.initial_options = [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2", description: ""}
      ]

      expect(multi_external_select).not_to be_valid
      expect(multi_external_select.errors["initial_options[1]"]).to include("is invalid: description can't be blank")

      multi_external_select.fix_validation_errors

      expect(multi_external_select.initial_options[1].description).to be_nil
      expect(multi_external_select).to be_valid
    end
  end
end
