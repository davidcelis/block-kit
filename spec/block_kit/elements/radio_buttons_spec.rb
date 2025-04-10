# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::RadioButtons, type: :model do
  subject(:radio_buttons) { described_class.new(attributes) }
  let(:attributes) do
    {
      options: [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2"}
      ]
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(radio_buttons.as_json).to eq({
        type: described_class.type.to_s,
        options: [
          {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
          {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
        ]
      })
    end
  end

  context "attributes" do
    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that has options", limit: 10, select: :single
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
  end

  context "validations" do
    it { is_expected.to be_valid }
  end
end
