# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::ChannelsSelect, type: :model do
  subject(:channels_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(channels_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_channel: "C12345678",
          response_url_enabled: false
        )
      end

      it "serializes to JSON" do
        expect(channels_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_channel: "C12345678",
          response_url_enabled: false
        })
      end
    end
  end

  context "attributes" do
    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder

    it { is_expected.to have_attribute(:initial_channel).with_type(:string) }
    it { is_expected.to have_attribute(:response_url_enabled).with_type(:boolean) }
  end

  context "validations" do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:initial_channel).allow_nil }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :initial_channel, null_value: {
      valid_values: ["anything", nil],
      invalid_values: [{before: "", after: nil}]
    }
  end
end
