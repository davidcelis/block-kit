# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::MultiConversationsSelect, type: :model do
  subject(:multi_conversations_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(multi_conversations_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_conversations: ["C12345678", "C23456789"],
          default_to_current_conversation: false,
          filter: BlockKit::Composition::ConversationFilter.new(include: [:public, :private])
        )
      end

      it "serializes to JSON" do
        expect(multi_conversations_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_conversations: ["C12345678", "C23456789"],
          default_to_current_conversation: false,
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
    it_behaves_like "a multi select"

    it { is_expected.to have_attribute(:initial_conversations).with_type(:set).containing(:string) }
    it { is_expected.to have_attribute(:default_to_current_conversation).with_type(:boolean) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates initial_conversations are all present" do
      multi_conversations_select.initial_conversations = ["C12345678", "", "C23456789", nil]

      expect(multi_conversations_select).not_to be_valid
      expect(multi_conversations_select.errors[:initial_conversations]).to include("must not contain blank values")
    end
  end

  context "fixers" do
    it "removes blank initial_conversations" do
      multi_conversations_select.initial_conversations = ["C12345678", "", "C23456789", nil]
      multi_conversations_select.fix_validation_errors

      expect(multi_conversations_select.initial_conversations.to_a).to eq(["C12345678", "C23456789"])
    end
  end
end
