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

  describe "#initial_option" do
    it "returns whatever was marked as initial last" do
      subject.options = [
        {text: "Option 1", value: "option_1", initial: true},
        {text: "Option 2", value: "option_2"},
        {text: "Option 3", value: "option_3", initial: true}
      ]

      expect(subject.initial_option.text.text).to eq("Option 3")
      expect(subject.initial_option.value).to eq("option_3")

      # Test that the validation works with option groups as well
      if subject.respond_to?(:option_groups)
        subject.option_groups = [
          {label: "Group 1", options: [{text: "Option A", value: "option_a", initial: true}]},
          {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
          {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
        ]

        expect(subject.initial_option.text.text).to eq("Option C")
        expect(subject.initial_option.value).to eq("option_c")
      end
    end
  end
end
