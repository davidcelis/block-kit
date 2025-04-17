require "spec_helper"

RSpec.shared_examples_for "a block that has option groups" do |limit:, options_limit:|
  it_behaves_like "a block that has options", limit: options_limit

  it_behaves_like "a block that has a DSL method",
    attribute: :option_groups,
    as: :option_group,
    type: BlockKit::Composition::OptionGroup,
    actual_fields: {label: "Some great options", options: [{text: "Option 1", value: "option_1", initial: true}], emoji: true},
    expected_fields: {
      label: BlockKit::Composition::PlainText.new(text: "Some great options", emoji: true),
      options: [BlockKit::Composition::Option.new(text: "Option 1", value: "option_1", initial: true)]
    },
    required_fields: [:label]

  describe "#as_json" do
    it "serializes option groups as JSON" do
      subject.option_groups = [
        {label: "Group 1", options: [{text: "Option A", value: "option_a"}]},
        {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
        {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
      ]

      expect(subject.as_json).to include(
        option_groups: [
          {label: {type: "plain_text", text: "Group 1"}, options: [{text: {type: "plain_text", text: "Option A"}, value: "option_a"}]},
          {label: {type: "plain_text", text: "Group 2"}, options: [{text: {type: "plain_text", text: "Option B"}, value: "option_b"}]},
          {label: {type: "plain_text", text: "Group 3"}, options: [{text: {type: "plain_text", text: "Option C"}, value: "option_c"}]}
        ]
      )
    end
  end

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

  it "automatically fixes invalid option_groups" do
    option_1 = BlockKit::Composition::Option.new(text: "Option 1", value: "option_1")
    option_2 = BlockKit::Composition::Option.new(text: "2" * (BlockKit::Composition::Option::MAX_TEXT_LENGTH + 2), value: "option_2")
    option_3 = BlockKit::Composition::Option.new(text: "Option 3", value: "option_3", description: "3" * (BlockKit::Composition::Option::MAX_DESCRIPTION_LENGTH + 3))
    option_group = BlockKit::Composition::OptionGroup.new(
      label: "a" * (BlockKit::Composition::OptionGroup::MAX_LABEL_LENGTH + 1),
      options: [option_1, option_2, option_3]
    )

    subject.options = nil
    subject.option_groups = [option_group]
    expect(option_group).not_to be_valid

    expect {
      subject.fix_validation_errors
    }.to change {
      option_group.label.length
    }.by(-1).and change {
      option_2.text.length
    }.by(-2).and change {
      option_3.description.length
    }.by(-3)
  end

  it "automatically fixes invalid option_groups with dangerous truncation" do
    subject.option_groups = []
    (limit + 1).times do |i|
      subject.option_groups << BlockKit::Composition::OptionGroup.new(label: "Group #{i + 1}")
    end

    expect {
      subject.fix_validation_errors
    }.not_to change {
      subject.option_groups.length
    }

    expect {
      subject.fix_validation_errors(dangerous: true)
    }.to change {
      subject.option_groups.length
    }.by(-1)
    expect(subject.option_groups.length).to eq(limit)
    expect(subject.option_groups.last.label.text).to eq("Group #{limit}")
  end
end
