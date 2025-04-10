# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::MultiChannelsSelect, type: :model do
  subject(:multi_channels_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(multi_channels_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_channels: ["C12345678", "C23456789"],
          max_selected_items: 3
        )
      end

      it "serializes to JSON" do
        expect(multi_channels_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_channels: ["C12345678", "C23456789"],
          max_selected_items: 3
        })
      end
    end
  end

  context "attributes" do
    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"

    it { is_expected.to have_attribute(:initial_channels).with_type(:array, :string) }
    it { is_expected.to have_attribute(:max_selected_items).with_type(:integer) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:max_selected_items).allow_nil }
    it { is_expected.not_to allow_value(0).for(:max_selected_items).with_message("must be greater than 0") }
  end
end
