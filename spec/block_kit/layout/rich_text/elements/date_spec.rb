# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Date, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) do
    {
      timestamp: "2025-04-11T10:28:59Z",
      format: "{date_long_pretty}"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        timestamp: 1744367339,
        format: "{date_long_pretty}"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          url: "https://example.com",
          fallback: "Oops! Something went wrong."
        )
      end

      it "includes all attributes" do
        expect(element.as_json).to eq({
          type: described_class.type.to_s,
          timestamp: 1744367339,
          format: "{date_long_pretty}",
          url: "https://example.com",
          fallback: "Oops! Something went wrong."
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:timestamp).with_type(:datetime) }
    it { is_expected.to have_attribute(:format).with_type(:string) }
    it { is_expected.to have_attribute(:url).with_type(:string) }
    it { is_expected.to have_attribute(:fallback).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:timestamp) }
    it { is_expected.to validate_presence_of(:format) }
    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.to allow_value("anything://is.fine/").for(:url) }
    it { is_expected.not_to allow_value("invalid_url").for(:url).with_message("is not a valid URI") }
    it { is_expected.not_to allow_value("").for(:url).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:fallback).allow_nil }
  end
end
