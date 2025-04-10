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
    it { is_expected.to have_attribute(:initial_options).with_type(:array, :block_kit_option) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "an external select"
  end

  context "validations" do
    it { is_expected.to be_valid }
  end
end
