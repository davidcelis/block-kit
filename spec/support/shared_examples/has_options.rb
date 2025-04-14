require "spec_helper"

RSpec.shared_examples_for "a block that has options" do |limit:, select: nil, groups: 0|
  it { is_expected.to have_attribute(:options).with_type(:array).containing(:block_kit_option) }

  describe "#option" do
    it "adds an option to the options array" do
      expect { subject.option(text: "New Option", value: "new") }.to change { subject.options.length }.by(1)
      expect(subject.options.last).to be_a(BlockKit::Composition::Option)
      expect(subject.options.last.text.text).to eq("New Option")
      expect(subject.options.last.value).to eq("new")
    end

    context "with optional args" do
      it "adds an option with all attributes set" do
        subject.option(text: "New Option", value: "new", description: "Description", initial: true, emoji: true)

        expect(subject.options.last.text.text).to eq("New Option")
        expect(subject.options.last.text.emoji).to be(true)
        expect(subject.options.last.value).to eq("new")
        expect(subject.options.last.description.text).to eq("Description")
        expect(subject.options.last).to be_initial
      end
    end
  end

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
          initial_option: {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
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
      expect(subject.errors["options[0]"]).to include("can't be initial when other options are also as initial")
      expect(subject.errors["options[1]"]).to be_empty
      expect(subject.errors["options[2]"]).to include("can't be initial when other options are also as initial")
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

    if select == :single
      it "retrieves the initial option from option groups" do
        subject.options = nil
        subject.option_groups = [
          {label: "Group 1", options: [{text: "Option A", value: "option_a"}]},
          {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
          {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
        ]

        expect(subject.initial_option.text.text).to eq("Option C")
        expect(subject.initial_option.value).to eq("option_c")
      end

      it "retrieves the initial option from options when groups are not present" do
        subject.options = [
          {text: "Option 1", value: "option_1", initial: true},
          {text: "Option 2", value: "option_2"},
          {text: "Option 3", value: "option_3"}
        ]
        subject.option_groups = nil

        expect(subject.initial_option.text.text).to eq("Option 1")
        expect(subject.initial_option.value).to eq("option_1")
      end
    else
      it "retrieves initial options from option groups" do
        subject.options = nil
        subject.option_groups = [
          {label: "Group 1", options: [{text: "Option A", value: "option_a", initial: true}]},
          {label: "Group 2", options: [{text: "Option B", value: "option_b"}]},
          {label: "Group 3", options: [{text: "Option C", value: "option_c", initial: true}]}
        ]

        expect(subject.initial_options.length).to eq(2)
        expect(subject.initial_options.first.text.text).to eq("Option A")
        expect(subject.initial_options.first.value).to eq("option_a")
        expect(subject.initial_options.last.text.text).to eq("Option C")
        expect(subject.initial_options.last.value).to eq("option_c")
      end

      it "retrieves initial options from options when groups are not present" do
        subject.options = [
          {text: "Option 1", value: "option_1", initial: true},
          {text: "Option 2", value: "option_2"},
          {text: "Option 3", value: "option_3", initial: true}
        ]
        subject.option_groups = nil

        expect(subject.initial_options.length).to eq(2)
        expect(subject.initial_options.first.text.text).to eq("Option 1")
        expect(subject.initial_options.first.value).to eq("option_1")
        expect(subject.initial_options.last.text.text).to eq("Option 3")
        expect(subject.initial_options.last.value).to eq("option_3")
      end
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
