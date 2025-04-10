# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::Overflow, type: :model do
  subject(:overflow) { described_class.new(attributes) }
  let(:attributes) do
    {
      options: [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2", url: "https://example.com"}
      ]
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(overflow.as_json).to eq({
        type: described_class.type.to_s,
        options: [
          {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
          {text: {type: "plain_text", text: "Option 2"}, value: "option_2", url: "https://example.com"}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:options).with_type(:array, :block_kit_overflow_option) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates that options are present" do
      subject.options = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:options]).to include("can't be blank")

      subject.options = []
      expect(subject).not_to be_valid
      expect(subject.errors[:options]).to include("can't be blank")
    end

    it "validates that there can be at most 5 options" do
      subject.options = Array.new(5) { {text: "Option", value: "value"} }
      expect(subject).to be_valid

      subject.options << {text: "Option 6", value: "value_6"}
      expect(subject).not_to be_valid
      expect(subject.errors[:options]).to include("is too long (maximum is 5 options)")
    end

    it "validates the associated options themselves" do
      subject.options = [{text: "Option 1", value: ""}]
      expect(subject).not_to be_valid
      expect(subject.errors["options[0]"]).to include("is invalid: value can't be blank")
    end
  end
end
