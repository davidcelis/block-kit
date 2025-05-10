# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Workflow, type: :model do
  subject(:block) { described_class.new(**attributes) }
  let(:attributes) { {trigger: {url: "https://example.com"}} }

  it_behaves_like "a class that yields self on initialize"

  it_behaves_like "a block that has a DSL method",
    attribute: :trigger,
    type: BlockKit::Composition::Trigger,
    actual_fields: {
      url: "https://example.com",
      customizable_input_parameters: [BlockKit::Composition::InputParameter.new(name: "greeting", value: "Hello, world!")]
    }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        trigger: {
          url: "https://example.com"
        }
      })
    end

    context "with a full trigger" do
      let(:trigger) do
        BlockKit::Composition::Trigger.new(
          url: "https://example.com",
          customizable_input_parameters: [
            BlockKit::Composition::InputParameter.new(name: "greeting", value: "Hello, world!")
          ]
        )
      end

      let(:attributes) { {trigger: trigger} }

      it "serializes to JSON with customizable input parameters" do
        expect(block.as_json).to eq({
          trigger: {
            url: "https://example.com",
            customizable_input_parameters: [
              {name: "greeting", value: "Hello, world!"}
            ]
          }
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:trigger) }

    it "validates the associated trigger" do
      block.trigger = BlockKit::Composition::Trigger.new(url: "")
      expect(block).not_to be_valid
      expect(block.errors[:trigger]).to include("is invalid: url can't be blank")
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:trigger).with_type(:block_kit_trigger) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :trigger, associated: {
      record: -> {
        BlockKit::Composition::Trigger.new(
          url: "https://example.com",
          customizable_input_parameters: []
        )
      },
      invalid_attribute: :customizable_input_parameters,
      fixed_attribute_value: nil
    }
  end
end
