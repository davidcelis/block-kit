require "spec_helper"

RSpec.shared_examples_for "a block that has initial options" do
  describe "#as_json" do
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

      if subject.respond_to?(:option_groups)
        subject.options = nil
        subject.option_groups = [
          {label: "Group 1", options: [{text: "Option A", value: "option_a", initial: true}]},
          {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
          {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
        ]

        expect(subject.as_json).to include(
          initial_options: [
            {text: {type: "plain_text", text: "Option A"}, value: "option_a"},
            {text: {type: "plain_text", text: "Option C"}, value: "option_c"}
          ]
        )
      end
    end
  end

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
