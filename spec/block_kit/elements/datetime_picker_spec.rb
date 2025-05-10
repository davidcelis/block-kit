# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::DatetimePicker, type: :model do
  subject(:datetime_picker) { described_class.new(attributes) }
  let(:attributes) { {} }

  it_behaves_like "a class that yields self on initialize"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(datetime_picker.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_date_time: Time.iso8601("2025-04-08T12:00:00Z")
        )
      end

      it "serializes to JSON" do
        expect(datetime_picker.as_json).to eq({
          type: described_class.type.to_s,
          initial_date_time: 1744113600
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_date_time).with_type(:datetime) }
    it { is_expected.to alias_attribute(:initial_date_time).as(:initial_datetime) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_datetime).allow_nil }
  end
end
