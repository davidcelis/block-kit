# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::TimePicker, type: :model do
  subject(:time_picker) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(time_picker.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_time: Time.iso8601("2025-04-08T12:34:00Z"),
          timezone: "America/Los_Angeles"
        )
      end

      it "serializes to JSON" do
        expect(time_picker.as_json).to eq({
          type: described_class.type.to_s,
          initial_time: "12:34",
          timezone: "America/Los_Angeles"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_time).with_type(:time) }
    it { is_expected.to have_attribute(:timezone).with_type(:string) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_time).allow_nil }
    it { is_expected.to validate_presence_of(:timezone).allow_nil }

    it "validates that the timezone exists" do
      time_picker.timezone = "America/Los_Angeles"
      expect(time_picker).to be_valid

      time_picker.timezone = "Invalid/Timezone"
      expect(time_picker).to be_invalid
      expect(time_picker.errors[:timezone]).to include("is not a valid timezone")

      time_picker.timezone = nil
      expect(time_picker).to be_valid
    end
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :timezone, null_value: {
      valid_values: ["America/Los_Angeles", "Europe/London", nil],
      invalid_values: [
        {before: "Invalid/Timezone", after: nil},
        {before: "invalid", after: nil},
        {before: "", after: nil}
      ]
    }
  end
end
