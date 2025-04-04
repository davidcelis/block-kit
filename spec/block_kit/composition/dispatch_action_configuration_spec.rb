# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::DispatchActionConfiguration, type: :model do
  subject(:config) { described_class.new(trigger_actions_on: ["on_enter_pressed", "on_character_entered"]) }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(config.as_json).to eq({
        trigger_actions_on: ["on_enter_pressed", "on_character_entered"]
      })
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:trigger_actions_on) }
    it { is_expected.to validate_inclusion_of(:trigger_actions_on).in_array(described_class::VALID_TRIGGERS) }
  end
end
