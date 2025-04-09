# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::DatePicker, type: :model do
  subject(:date_picker) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(date_picker.as_json).to eq({type: described_class::TYPE})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_date: Date.new(2025, 4, 8),
          placeholder: "Select a date"
        )
      end

      it "serializes to JSON" do
        expect(date_picker.as_json).to eq({
          type: described_class::TYPE,
          initial_date: "2025-04-08",
          placeholder: {type: "plain_text", text: "Select a date"}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_date).with_type(:date) }
    it { is_expected.to have_attribute(:placeholder).with_type(:block_kit_plain_text) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_date).allow_nil }
    it { is_expected.to validate_presence_of(:placeholder).allow_nil }
    it { is_expected.to validate_length_of(:placeholder).is_at_most(150) }
  end
end
