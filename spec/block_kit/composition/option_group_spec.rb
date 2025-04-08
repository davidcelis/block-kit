# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::OptionGroup, type: :model do
  subject(:option_group) { described_class.new(**attributes) }
  let(:attributes) do
    {
      label: "Some great options",
      options: [{text: "Option 1", value: "option_1"}]
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(option_group.as_json).to eq({
        label: {type: "plain_text", text: "Some great options"},
        options: [{text: {type: "plain_text", text: "Option 1"}, value: "option_1"}]
      })
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_most(75) }

    it "validates that options are present" do
      option_group.options = nil
      expect(option_group).not_to be_valid
      expect(option_group.errors[:options]).to include("can't be blank")

      option_group.options = []
      expect(option_group).not_to be_valid
      expect(option_group.errors[:options]).to include("can't be blank")
    end

    it "validates that there can be at most 100 options" do
      option_group.options = Array.new(101) { {text: "Option", value: "value"} }
      expect(option_group).not_to be_valid
      expect(option_group.errors[:options]).to include("is too long (maximum is 100 options)")
    end

    it "validates the associated options themselves" do
      option_group.options = [{text: "Option 1", value: ""}]
      expect(option_group).not_to be_valid
      expect(option_group.errors["options[0]"]).to include("is invalid: value can't be blank")
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:label).with_type(:block_kit_plain_text) }

    it_behaves_like "a block with required attributes", :label
  end
end
