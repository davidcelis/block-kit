# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::MultiExternalSelect, type: :model do
  subject(:multi_external_select) { described_class.new(attributes) }
  let(:attributes) { {} }

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
          ],
          min_query_length: 3,
          max_selected_items: 3
        )
      end

      it "serializes to JSON" do
        expect(multi_external_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ],
          min_query_length: 3,
          max_selected_items: 3
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_options).with_type(:array, :block_kit_option) }
    it { is_expected.to have_attribute(:max_selected_items).with_type(:integer) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:min_query_length).allow_nil }
    it { is_expected.not_to allow_value(-1).for(:min_query_length).with_message("must be greater than or equal to 0") }
    it { is_expected.to validate_presence_of(:max_selected_items).allow_nil }
    it { is_expected.not_to allow_value(0).for(:max_selected_items).with_message("must be greater than 0") }
  end
end
