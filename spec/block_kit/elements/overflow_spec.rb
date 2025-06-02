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

  it_behaves_like "a class that yields self on initialize"

  it_behaves_like "a block that has a DSL method",
    attribute: :options,
    as: :option,
    type: BlockKit::Composition::OverflowOption,
    actual_fields: {text: "New Option", value: "new", description: "Description", url: "https://example.com", emoji: true},
    expected_fields: {
      text: BlockKit::Composition::PlainText.new(text: "New Option", emoji: true),
      value: "new",
      description: BlockKit::Composition::PlainText.new(text: "Description", emoji: true),
      url: "https://example.com"
    },
    required_fields: [:text, :value],
    yields: false

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
    it { is_expected.to have_attribute(:options).with_type(:array).containing(:block_kit_overflow_option).with_default_value([]) }

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

  context "fixers" do
    it "fixes the associated options" do
      subject.options = [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2", description: ""}
      ]

      expect(subject).not_to be_valid
      expect(subject.errors["options[1]"]).to include("is invalid: description can't be blank")

      subject.fix_validation_errors

      expect(subject.options[1].description).to be_nil
      expect(subject).to be_valid
    end

    it "automatically fixes invalid options with dangerous truncation" do
      subject.options = (described_class::MAX_OPTIONS + 1).times.map do |i|
        BlockKit::Composition::Option.new(text: "Option #{i + 1}", value: i + 1)
      end

      expect {
        subject.fix_validation_errors
      }.not_to change {
        subject.options.length
      }

      expect {
        subject.fix_validation_errors(dangerous: true)
      }.to change {
        subject.options.length
      }.by(-1)
      expect(subject.options.length).to eq(described_class::MAX_OPTIONS)
      expect(subject.options.last.text.text).to eq("Option #{described_class::MAX_OPTIONS}")
    end
  end
end
