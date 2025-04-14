# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::DispatchActionConfig, type: :model do
  subject(:config) { described_class.new(trigger_actions_on: ["on_enter_pressed", "on_character_entered"]) }

  it "declares predicate and mutator methods for each trigger_actions_on value" do
    config = described_class.new

    described_class::VALID_TRIGGERS.each do |value|
      expect(config.public_send(:"trigger_actions_on_#{value}?")).to be(false)
      config.public_send(:"trigger_actions_on_#{value}!")
      expect(config.trigger_actions_on).to include(value)
      expect(config.public_send(:"trigger_actions_on_#{value}?")).to be(true)
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(config.as_json).to eq({
        trigger_actions_on: ["on_enter_pressed", "on_character_entered"]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:trigger_actions_on).with_type(:set).containing(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:trigger_actions_on) }
    it { is_expected.to validate_array_inclusion_of(:trigger_actions_on).in_array(described_class::VALID_TRIGGERS) }
  end
end
