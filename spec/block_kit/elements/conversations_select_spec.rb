# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::ConversationsSelect, type: :model do
  subject(:conversations_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  it_behaves_like "a class that yields self on initialize"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(conversations_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_conversation: "C12345678",
          default_to_current_conversation: false,
          response_url_enabled: false,
          filter: BlockKit::Composition::ConversationFilter.new(include: [:public, :private])
        )
      end

      it "serializes to JSON" do
        expect(conversations_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_conversation: "C12345678",
          default_to_current_conversation: false,
          response_url_enabled: false,
          filter: {include: ["public", "private"]}
        })
      end
    end
  end

  context "attributes" do
    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
    it_behaves_like "a conversation selector"

    it { is_expected.to have_attribute(:initial_conversation).with_type(:string) }
    it { is_expected.to have_attribute(:response_url_enabled).with_type(:boolean) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_conversation).allow_nil }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :initial_conversation, null_value: {
      valid_values: ["anything", nil],
      invalid_values: [{before: "", after: nil}]
    }
  end
end
