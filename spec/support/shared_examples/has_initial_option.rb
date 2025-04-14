require "spec_helper"

RSpec.shared_examples_for "a block that has one initial option" do
  it "serializes the initial_option as JSON" do
    subject.options = [
      {text: "Option 1", value: "option_1"},
      {text: "Option 2", value: "option_2", initial: true}
    ]

    expect(subject.as_json).to include(
      initial_option: {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
    )

    if subject.respond_to?(:option_groups)
      subject.options = nil
      subject.option_groups = [
        {label: "Group 1", options: [{text: "Option A", value: "option_a"}]},
        {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
        {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
      ]

      expect(subject.as_json).to include(
        initial_option: {text: {type: "plain_text", text: "Option C"}, value: "option_c"}
      )
    end
  end

  it "validates that only one option can be initial" do
    subject.options = [
      {text: "Option 1", value: "option_1", initial: true},
      {text: "Option 2", value: "option_2"},
      {text: "Option 3", value: "option_3", initial: true}
    ]

    expect(subject).not_to be_valid
    expect(subject.errors["options[0]"]).to include("can't be initial when other options are also as initial")
    expect(subject.errors["options[1]"]).to be_empty
    expect(subject.errors["options[2]"]).to include("can't be initial when other options are also as initial")

    # Test that the validation works with option groups as well
    if subject.respond_to?(:option_groups)
      subject.option_groups = [
        {label: "Group 1", options: [{text: "Option A", value: "option_a", initial: true}]},
        {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
        {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
      ]

      expect(subject).not_to be_valid
      expect(subject.errors["options[0]"]).to include("can't be initial when other options are also as initial")
      expect(subject.errors["options[1]"]).to be_empty
      expect(subject.errors["options[2]"]).to include("can't be initial when other options are also as initial")
      expect(subject.errors["option_groups[0].options[0]"]).to include("can't be initial when other options are also as initial")
      expect(subject.errors["option_groups[1].options[0]"]).to be_empty
      expect(subject.errors["option_groups[2].options[0]"]).to include("can't be initial when other options are also as initial")
    end
  end
end
