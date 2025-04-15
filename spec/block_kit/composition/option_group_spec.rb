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

  it_behaves_like "a block that has a DSL method",
    attribute: :options,
    as: :option,
    type: BlockKit::Composition::Option,
    actual_fields: {text: "New Option", value: "new", description: "Description", initial: true, emoji: true},
    expected_fields: {
      text: BlockKit::Composition::PlainText.new(text: "New Option", emoji: true),
      value: "new",
      description: BlockKit::Composition::PlainText.new(text: "Description", emoji: true),
      initial: true
    },
    required_fields: [:text, :value],
    yields: false

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

    it_behaves_like "a block that has options", limit: 100
  end

  context "attributes" do
    it_behaves_like "a block that has plain text attributes", :label
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :label, truncate: {maximum: described_class::MAX_LABEL_LENGTH}
  end
end
