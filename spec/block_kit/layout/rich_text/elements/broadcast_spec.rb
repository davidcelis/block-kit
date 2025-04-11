# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Broadcast, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {range: "everyone"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        range: "everyone"
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:range).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:range) }
    it { is_expected.to validate_inclusion_of(:range).in_array(described_class::VALID_RANGES) }
  end
end
