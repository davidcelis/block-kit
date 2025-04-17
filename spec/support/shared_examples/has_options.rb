require "spec_helper"
require "active_support/core_ext/object/inclusion"

RSpec.shared_examples_for "a block that has options" do |limit:|
  it { is_expected.to have_attribute(:options).with_type(:array).containing(:block_kit_option) }

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
    it "serializes options as JSON" do
      subject.options = [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2"}
      ]

      expect(subject.as_json).to include(
        options: [
          {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
          {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
        ]
      )
    end
  end

  it "validates that there can be at most #{limit} options" do
    subject.options = Array.new(limit + 1) { {text: "Option", value: "value"} }
    expect(subject).not_to be_valid
    expect(subject.errors[:options]).to include("is too long (maximum is #{limit} options)")
  end

  it "validates the associated options themselves" do
    subject.options = [{text: "Option 1", value: ""}]
    expect(subject).not_to be_valid
    expect(subject.errors["options[0]"]).to include("is invalid: value can't be blank")
  end

  it "validates that options are present" do
    # Skip this test if the block has option groups
    next if subject.respond_to?(:option_groups)

    subject.options = nil
    expect(subject).not_to be_valid
    expect(subject.errors[:options]).to include("can't be blank")

    subject.options = []
    expect(subject).not_to be_valid
    expect(subject.errors[:options]).to include("can't be blank")
  end

  it "automatically fixes invalid options with dangerous truncation" do
    subject.options = (limit + 1).times.map do |i|
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
    expect(subject.options.length).to eq(limit)
    expect(subject.options.last.text.text).to eq("Option #{limit}")
  end
end
