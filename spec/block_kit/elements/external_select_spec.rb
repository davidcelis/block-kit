# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::ExternalSelect, type: :model do
  subject(:external_select) { described_class.new(attributes) }
  let(:attributes) { {} }

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
    it { is_expected.to have_attribute(:max_selected_items).with_type(:integer) }

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
