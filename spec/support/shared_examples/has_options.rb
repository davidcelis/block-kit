require "spec_helper"

RSpec.shared_examples_for "a block that has options" do |limit:|
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
end
