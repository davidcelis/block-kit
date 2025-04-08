# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::Button, type: :model do
  subject(:button) { described_class.new(attributes) }
  let(:attributes) do
    {
      text: "My Button",
      value: "button_value"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(button.as_json).to eq({
        type: described_class::TYPE,
        text: {type: "plain_text", text: "My Button"},
        value: "button_value"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          url: "https://example.com",
          style: "primary",
          confirm: {
            title: "Dialog Title",
            text: "Dialog Text",
            confirm: "Yes",
            deny: "No"
          },
          accessibility_label: "My Button Label"
        )
      end

      it "serializes to JSON" do
        expect(button.as_json).to eq({
          type: described_class::TYPE,
          text: {type: "plain_text", text: "My Button"},
          url: "https://example.com",
          value: "button_value",
          style: "primary",
          confirm: button.confirm.as_json,
          accessibility_label: "My Button Label"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:block_kit_plain_text) }
    it { is_expected.to have_attribute(:url).with_type(:string) }
    it { is_expected.to have_attribute(:value).with_type(:string) }
    it { is_expected.to have_attribute(:style).with_type(:string) }
    it { is_expected.to have_attribute(:confirm).with_type(:block_kit_confirmation_dialog) }
    it { is_expected.to have_attribute(:accessibility_label).with_type(:string) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block with required attributes", :text
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(75) }

    it { is_expected.to validate_presence_of(:url).allow_nil }
    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.to allow_value("anything://is.fine/").for(:url) }
    it { is_expected.not_to allow_value("invalid_url").for(:url).with_message("is not a valid URI") }
    it { is_expected.to validate_length_of(:url).is_at_most(3000) }

    it { is_expected.to validate_presence_of(:value).allow_nil }
    it { is_expected.to validate_length_of(:value).is_at_most(2000).allow_nil }
    it { is_expected.to validate_presence_of(:style).allow_nil }
    it { is_expected.to validate_inclusion_of(:style).in_array(%w[primary danger]).allow_nil }
    it { is_expected.to validate_presence_of(:confirm).allow_nil }
    it { is_expected.to validate_presence_of(:accessibility_label).allow_nil }
    it { is_expected.to validate_length_of(:accessibility_label).is_at_most(75) }

    it "validates the associated confirmation dialog" do
      button.confirm = BlockKit::Composition::ConfirmationDialog.new(
        title: "",
        text: "Dialog Text",
        confirm: "Yes",
        deny: "No"
      )

      expect(button).not_to be_valid
      expect(button.errors[:confirm]).to include("is invalid: title can't be blank")
    end
  end
end
