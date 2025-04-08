# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Workflow, type: :model do
  subject(:workflow) { described_class.new(**attributes) }
  let(:attributes) { {trigger: {url: "https://example.com"}} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(workflow.as_json).to eq({
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
        expect(workflow.as_json).to eq({
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
      workflow.trigger = BlockKit::Composition::Trigger.new(url: "")
      expect(workflow).not_to be_valid
      expect(workflow.errors[:trigger]).to include("is invalid: url can't be blank")
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:trigger).with_type(:block_kit_trigger) }

    it_behaves_like "a block with required attributes", :trigger
  end
end
