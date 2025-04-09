# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::MultiStaticSelect, type: :model do
  subject(:multi_static_select) { described_class.new(attributes) }
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
      expect(multi_static_select.as_json).to eq({
        type: described_class.type.to_s,
        options: [
          {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
          {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
        ]
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          max_selected_items: 3,
          placeholder: "Select an option"
        )
      end

      it "serializes to JSON" do
        expect(multi_static_select.as_json).to eq({
          type: described_class.type.to_s,
          placeholder: {type: "plain_text", text: "Select an option"},
          max_selected_items: 3,
          options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ]
        })
      end
    end
  end

  context "attributes" do
    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that has options", limit: 100, select: :multi, groups: 100
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"

    it { is_expected.to have_attribute(:max_selected_items).with_type(:integer) }
    it { is_expected.to have_attribute(:placeholder).with_type(:block_kit_plain_text) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:max_selected_items).allow_nil }
    it { is_expected.not_to allow_value(0).for(:max_selected_items).with_message("must be greater than 0") }
    it { is_expected.to validate_presence_of(:placeholder).allow_nil }
    it { is_expected.to validate_length_of(:placeholder).is_at_most(150).allow_nil }
  end
end
