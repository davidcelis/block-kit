# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Option, type: :model do
  subject(:option) { described_class.new(**attributes) }
  let(:attributes) do
    {
      text: "A great option",
      value: "option_1"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(option.as_json).to eq({
        text: {type: "plain_text", text: "A great option"},
        value: "option_1"
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(description: "This option is great!", initial: true) }

      it "serializes to JSON" do
        expect(option.as_json).to eq({
          text: {type: "plain_text", text: "A great option"},
          value: "option_1",
          description: {type: "plain_text", text: "This option is great!"}
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(75) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_length_of(:value).is_at_most(150) }
    it { is_expected.to validate_presence_of(:description).allow_nil }
    it { is_expected.to validate_length_of(:description).is_at_most(75) }
  end

  context "attributes" do
    it { is_expected.to have_attribute(:value).with_type(:string) }
    it { is_expected.to have_attribute(:initial).with_type(:boolean) }

    it "has a predicate for initial" do
      expect(option).not_to be_initial
      option.initial = true
      expect(option).to be_initial
    end

    it_behaves_like "a block that has plain text attributes", :text, :description
    it_behaves_like "a block that has plain text emoji assignment", :text, :description
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :text, truncate: {maximum: described_class::MAX_TEXT_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :value, truncate: {maximum: described_class::MAX_VALUE_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :description, truncate: {maximum: described_class::MAX_DESCRIPTION_LENGTH}
  end
end
