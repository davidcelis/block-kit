# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::OptionGroup, type: :model do
  subject(:option_group) { described_class.new(**attributes) }
  let(:attributes) do
    {
      label: "Some great options",
      options: [{text: "Option 1", value: "option_1"}]
    }
  end

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
    it "serializes to JSON" do
      expect(option_group.as_json).to eq({
        label: {type: "plain_text", text: "Some great options"},
        options: [{text: {type: "plain_text", text: "Option 1"}, value: "option_1"}]
      })
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_most(75) }

    it_behaves_like "a block that has options", limit: 100
  end

  context "attributes" do
    it { is_expected.to have_attribute(:label).with_type(:block_kit_plain_text) }
  end
end
