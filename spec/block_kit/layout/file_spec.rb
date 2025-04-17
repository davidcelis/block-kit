# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::File, type: :model do
  subject(:slack_file) { described_class.new(**attributes) }
  let(:attributes) { {external_id: "file_id"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(slack_file.as_json).to eq({
        type: described_class.type.to_s,
        external_id: "file_id",
        source: "remote"
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:external_id).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_length_of(:external_id).is_at_most(255) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors",
      attribute: :external_id,
      truncate: {maximum: described_class::MAX_EXTERNAL_ID_LENGTH, dangerous: true}
  end
end
