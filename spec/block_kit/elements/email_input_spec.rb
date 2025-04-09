# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::EmailInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({type: described_class::TYPE})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_value: "hello@example.com",
          dispatch_action_config: BlockKit::Composition::DispatchActionConfiguration.new(trigger_actions_on: ["on_enter_pressed"]),
          placeholder: "Enter your email"
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class::TYPE,
          initial_value: "hello@example.com",
          dispatch_action_config: {trigger_actions_on: ["on_enter_pressed"]},
          placeholder: {type: "plain_text", text: "Enter your email"}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_value).with_type(:string) }
    it { is_expected.to have_attribute(:dispatch_action_config).with_type(:block_kit_dispatch_action_configuration) }
    it { is_expected.to have_attribute(:placeholder).with_type(:block_kit_plain_text) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is focusable on load"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_value).allow_nil }
    it { is_expected.to allow_value("hello@example.com").for(:initial_value) }
    it { is_expected.not_to allow_value("invalidemail.com").for(:initial_value) }
    it { is_expected.not_to allow_value("invalidemail@.com").for(:initial_value) }
    it { is_expected.to validate_presence_of(:placeholder).allow_nil }
    it { is_expected.to validate_length_of(:placeholder).is_at_most(150) }

    it { is_expected.to validate_presence_of(:dispatch_action_config).allow_nil }

    it "validates the associated dispatch_action_config" do
      subject.dispatch_action_config = BlockKit::Composition::DispatchActionConfiguration.new(trigger_actions_on: [])
      expect(subject).not_to be_valid
      expect(subject.errors[:dispatch_action_config]).to include("is invalid: trigger_actions_on can't be blank")
    end
  end
end
