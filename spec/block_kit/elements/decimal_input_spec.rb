# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::DecimalInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({
        type: described_class.type.to_s,
        is_decimal_allowed: true
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_value: 7.77,
          min_value: 0.1,
          max_value: 9.9,
          dispatch_action_config: BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"]),
          placeholder: "Pick a number"
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class.type.to_s,
          is_decimal_allowed: true,
          initial_value: "7.77",
          min_value: "0.1",
          max_value: "9.9",
          dispatch_action_config: {trigger_actions_on: ["on_enter_pressed"]},
          placeholder: {type: "plain_text", text: "Pick a number"}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_value).with_type(:decimal) }
    it { is_expected.to have_attribute(:min_value).with_type(:decimal) }
    it { is_expected.to have_attribute(:max_value).with_type(:decimal) }
    it { is_expected.to have_attribute(:dispatch_action_config).with_type(:block_kit_dispatch_action_config) }
    it { is_expected.to have_attribute(:placeholder).with_type(:block_kit_plain_text) }

    it { is_expected.to alias_attribute(:dispatch_action_config).as(:dispatch_action_configuration) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is focusable on load"
  end

  context "validations" do
    it { is_expected.to be_valid }

    describe "numericality" do
      # Randomize this to better ensure coverage
      let(:min_value) { rand(0.0..5.0) }
      let(:max_value) { rand(5.0..10.0) }

      let(:attributes) do
        {
          min_value: min_value,
          max_value: max_value
        }
      end

      it { is_expected.to allow_value(min_value).for(:initial_value) }
      it { is_expected.to allow_value(max_value).for(:initial_value) }
      it { is_expected.to allow_value(nil).for(:initial_value) }
      it { is_expected.not_to allow_value(min_value - 1).for(:initial_value) }
      it { is_expected.not_to allow_value(max_value + 1).for(:initial_value) }

      it { is_expected.to allow_value(min_value).for(:min_value) }
      it { is_expected.to allow_value(nil).for(:min_value) }
      it { is_expected.not_to allow_value(max_value + 1).for(:min_value) }

      it { is_expected.to allow_value(max_value).for(:max_value) }
      it { is_expected.to allow_value(nil).for(:max_value) }
      it { is_expected.not_to allow_value(min_value - 1).for(:max_value) }
    end

    it { is_expected.to validate_presence_of(:dispatch_action_config).allow_nil }

    it "validates the associated dispatch_action_config" do
      subject.dispatch_action_config = BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: [])
      expect(subject).not_to be_valid
      expect(subject.errors[:dispatch_action_config]).to include("is invalid: trigger_actions_on can't be blank")
    end
  end
end
