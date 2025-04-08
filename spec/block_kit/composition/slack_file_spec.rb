# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::SlackFile, type: :model do
  subject(:slack_file) { described_class.new(**attributes) }
  let(:attributes) { {url: "https://example.com"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(slack_file.as_json).to eq({url: "https://example.com"})
    end

    context "with an ID instead of URL" do
      let(:attributes) { {id: "F12345678"} }

      it "serializes to JSON with customizable input parameters" do
        expect(slack_file.as_json).to eq({id: "F12345678"})
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:url).allow_nil }
    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:url).with_message("is not a valid URI") }
    it { is_expected.not_to allow_value("invalid_url").for(:url).with_message("is not a valid URI") }

    it { is_expected.to validate_presence_of(:id).allow_nil }
    it { is_expected.to allow_value("F12345678").for(:id) }
    it { is_expected.to allow_value("F1A2B3C4D5E").for(:id) }
    it { is_expected.not_to allow_value("F1234567").for(:id) }
    it { is_expected.not_to allow_value("f12345678").for(:id) }
    it { is_expected.not_to allow_value("F1a2b3c4d5e").for(:id) }

    it "validates that one (and only one) of id or url is present" do
      slack_file.id = nil
      slack_file.url = nil

      expect(slack_file).not_to be_valid
      expect(slack_file.errors[:base]).to include("must have either an id or url, but not both")

      slack_file.id = "F12345678"
      slack_file.url = "https://example.com"

      expect(slack_file).not_to be_valid
      expect(slack_file.errors[:base]).to include("must have either an id or url, but not both")
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:id).with_type(:string) }
    it { is_expected.to have_attribute(:url).with_type(:string) }
  end
end
