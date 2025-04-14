require "spec_helper"

RSpec.shared_examples_for "a block that has option groups" do |limit:, options_limit:|
  it_behaves_like "a block that has options", limit: options_limit

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
end
