# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::ConfirmationDialog, type: :model do
  subject(:dialog) { described_class.new(attributes) }
  let(:attributes) do
    {
      title: "Dialog Title",
      text: "Dialog Text",
      confirm: "Yes",
      deny: "No"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(dialog.as_json).to eq({
        title: {type: "plain_text", text: "Dialog Title"},
        text: {type: "plain_text", text: "Dialog Text"},
        confirm: {type: "plain_text", text: "Yes"},
        deny: {type: "plain_text", text: "No"}
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(style: "danger") }

      it "serializes to JSON" do
        expect(dialog.as_json[:style]).to eq("danger")
      end
    end
  end

  context "attributes" do
    it_behaves_like "a block that has plain text attributes", :title, :text, :confirm, :deny

    it { is_expected.to have_attribute(:style).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(300) }
    it { is_expected.to validate_presence_of(:confirm) }
    it { is_expected.to validate_length_of(:confirm).is_at_most(30) }
    it { is_expected.to validate_presence_of(:deny) }
    it { is_expected.to validate_length_of(:deny).is_at_most(30) }
    it { is_expected.to validate_presence_of(:style).allow_nil }
    it { is_expected.to validate_inclusion_of(:style).in_array(%w[primary danger]) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :title, truncate: {maximum: described_class::MAX_TITLE_TEXT_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :text, truncate: {maximum: described_class::MAX_TEXT_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :confirm, truncate: {maximum: described_class::MAX_BUTTON_TEXT_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :deny, truncate: {maximum: described_class::MAX_BUTTON_TEXT_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :style, null_value: {
      valid_values: described_class::VALID_STYLES + [nil],
      invalid_values: [
        {before: "", after: nil},
        {before: "invalid", after: nil}
      ]
    }
  end
end
