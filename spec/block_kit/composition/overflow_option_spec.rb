# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::OverflowOption, type: :model do
  subject(:option) { described_class.new(**attributes) }
  let(:attributes) do
    {
      text: "A great option",
      value: "option_1"
    }
  end

  it { is_expected.to be_a(BlockKit::Composition::Option) }

  describe "#as_json" do
    context "with all attributes" do
      let(:attributes) { super().merge(description: "This option is great!", url: "https://example.com/") }

      it "serializes to JSON" do
        expect(option.as_json).to eq({
          text: {type: "plain_text", text: "A great option"},
          value: "option_1",
          description: {type: "plain_text", text: "This option is great!"},
          url: "https://example.com/"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:url).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:url).allow_nil }
    it { is_expected.to validate_length_of(:url).is_at_most(3000) }

    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.to allow_value("anything://is.fine/").for(:url) }
    it { is_expected.not_to allow_value("invalid_url").for(:url).with_message("is not a valid URI") }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :url, null_value: {
      valid_values: ["http://example.com/", "https://example.com/", "anything://is.fine/", nil],
      invalid_values: [
        {before: "invalid_url", after: "invalid_url", still_invalid: true},
        {before: "", after: nil}
      ]
    }
  end
end
