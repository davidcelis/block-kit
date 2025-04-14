# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::StaticSelect, type: :model do
  subject(:static_select) { described_class.new(attributes) }
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
      expect(static_select.as_json).to eq({
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
    it_behaves_like "a block that has option groups", limit: 100, options_limit: 100
    it_behaves_like "a block that has one initial option"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }
  end
end
