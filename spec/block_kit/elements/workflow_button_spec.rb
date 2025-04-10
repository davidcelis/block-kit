# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::WorkflowButton, type: :model do
  subject(:button) { described_class.new(attributes) }
  let(:attributes) do
    {
      text: "My Workflow",
      workflow: BlockKit::Composition::Workflow.new(
        trigger: BlockKit::Composition::Trigger.new(
          url: "https://example.com",
          customizable_input_parameters: [
            BlockKit::Composition::InputParameter.new(name: "greeting", value: "Hello, world!")
          ]
        )
      )
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(button.as_json).to eq({
        type: described_class.type.to_s,
        text: {type: "plain_text", text: "My Workflow"},
        workflow: {
          trigger: {
            url: "https://example.com",
            customizable_input_parameters: [
              {name: "greeting", value: "Hello, world!"}
            ]
          }
        }
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:workflow).with_type(:block_kit_workflow) }

    it_behaves_like "a button"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates the associated workflow" do
      button.workflow.trigger.url = nil
      expect(button).not_to be_valid
      expect(button.errors[:workflow]).to include("is invalid: trigger.url can't be blank")
    end
  end
end
