# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::Button, type: :model do
  subject(:button) { described_class.new(attributes) }
  let(:attributes) { {text: "My Button"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(button.as_json).to eq({
        text: {type: "plain_text", text: "My Button"},
        type: described_class.type.to_s
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          url: "https://example.com",
          value: "button_value"
        )
      end

      it "serializes to JSON" do
        expect(button.as_json).to eq({
          type: described_class.type.to_s,
          text: {type: "plain_text", text: "My Button"},
          url: "https://example.com",
          value: "button_value"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:url).with_type(:string) }
    it { is_expected.to have_attribute(:value).with_type(:string) }

    it_behaves_like "a button"
    it_behaves_like "a block that is confirmable"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:url).allow_nil }
    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.to allow_value("anything://is.fine/").for(:url) }
    it { is_expected.not_to allow_value("invalid_url").for(:url).with_message("is not a valid URI") }
    it { is_expected.to validate_length_of(:url).is_at_most(3000) }

    it { is_expected.to validate_presence_of(:value).allow_nil }
    it { is_expected.to validate_length_of(:value).is_at_most(2000).allow_nil }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors",
      attribute: :url,
      truncate: {maximum: described_class::MAX_URL_LENGTH, dangerous: true},
      null_value: {
        valid_values: ["http://example.com/", "https://example.com/", "anything://is.fine/", nil],
        invalid_values: [
          {before: "invalid_url", after: "invalid_url", still_invalid: true},
          {before: "", after: nil}
        ]
      }

    it_behaves_like "a block that fixes validation errors",
      attribute: :value,
      truncate: {maximum: described_class::MAX_URL_LENGTH, dangerous: true},
      null_value: {
        valid_values: ["anything", nil],
        invalid_values: [{before: "", after: nil}]
      }
  end
end
