# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Color, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {value: "red"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        value: "red"
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:value).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:value) }
  end
end
