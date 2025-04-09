require "spec_helper"

RSpec.shared_examples_for "a block that has options" do |limit:, select: nil, groups: 0|
  it { is_expected.to have_attribute(:options).with_type(:array, :block_kit_option) }

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

    case select
    when :single
      it "serializes the initial_option as JSON" do
        subject.options = [
          {text: "Option 1", value: "option_1"},
          {text: "Option 2", value: "option_2", initial: true}
        ]

        expect(subject.as_json).to include(
          initial_option: [
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ]
        )
      end
    when :multi
      it "serializes all initial_options as JSON" do
        subject.options = [
          {text: "Option 1", value: "option_1", initial: true},
          {text: "Option 2", value: "option_2"},
          {text: "Option 3", value: "option_3", initial: true}
        ]

        expect(subject.as_json).to include(
          initial_options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 3"}, value: "option_3"}
          ]
        )
      end
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

  if select == :single
    it "validates that only one option can be initial" do
      subject.options = [
        {text: "Option 1", value: "option_1", initial: true},
        {text: "Option 2", value: "option_2"},
        {text: "Option 3", value: "option_3", initial: true}
      ]

      expect(subject).not_to be_valid
      expect(subject.errors["options[0]"]).to include("cannot be initial when other options are also as initial")
      expect(subject.errors["options[1]"]).to be_empty
      expect(subject.errors["options[2]"]).to include("cannot be initial when other options are also as initial")
    end
  else
    it "is valid with multiple initial options" do
      subject.options = [
        {text: "Option 1", value: "option_1", initial: true},
        {text: "Option 2", value: "option_2"},
        {text: "Option 3", value: "option_3", initial: true}
      ]

      subject.validate

      expect(subject.errors["options[0]"]).to be_empty
      expect(subject.errors["options[1]"]).to be_empty
      expect(subject.errors["options[2]"]).to be_empty
    end
  end

  if groups > 0
    it "validates that options or option groups (but not both) are present" do
      subject.options = nil
      subject.option_groups = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("must have either options or option groups, not both")

      subject.options = []
      subject.option_groups = []
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("must have either options or option groups, not both")

      subject.options = [{text: "Option 1", value: "option_1"}]
      subject.option_groups = []
      expect(subject).to be_valid

      subject.options = []
      subject.option_groups = [{label: "Group 1", options: [{text: "Option A", value: "option_a"}]}]
      expect(subject).to be_valid

      subject.options = [{text: "Option 1", value: "option_1"}]
      subject.option_groups = [{label: "Group 1", options: [{text: "Option A", value: "option_a"}]}]
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("must have either options or option groups, not both")
    end
  else
    it "validates that options are present" do
      subject.options = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:options]).to include("can't be blank")

      subject.options = []
      expect(subject).not_to be_valid
      expect(subject.errors[:options]).to include("can't be blank")
    end
  end
end
