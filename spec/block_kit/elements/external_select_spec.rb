# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::ExternalSelect, type: :model do
  subject(:external_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  it_behaves_like "a class that yields self on initialize"

  it_behaves_like "a block that has a DSL method",
    attribute: :initial_option,
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
      expect(external_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) { super().merge(initial_option: {text: "Option 1", value: "option_1"}) }

      it "serializes to JSON" do
        expect(external_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_option: {text: {type: "plain_text", text: "Option 1"}, value: "option_1"}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_option).with_type(:block_kit_option) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "an external select"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates the associated initial_option" do
      external_select.initial_option = {text: "Option 1", value: "option_1"}
      expect(external_select).to be_valid

      external_select.initial_option = {text: "Option 1"}
      expect(external_select).not_to be_valid
      expect(external_select.errors[:initial_option]).to include("is invalid: value can't be blank")
    end
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :initial_option, associated: {
      record: -> {
        BlockKit::Composition::Option.new(text: "Option 1", value: "option_1", description: "")
      },
      invalid_attribute: :description,
      fixed_attribute_value: nil
    }
  end
end
