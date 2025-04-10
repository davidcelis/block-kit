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
          max_selected_items: 3,
          placeholder: "Select a user",
          filter: BlockKit::Composition::ConversationFilter.new(include: [:public, :private])
        )
      end

      it "serializes to JSON" do
        expect(multi_conversations_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_conversations: ["C12345678", "C23456789"],
          default_to_current_conversation: false,
          max_selected_items: 3,
          placeholder: {type: "plain_text", text: "Select a user"},
          filter: {include: ["public", "private"]}
        })
      end
    end
  end

  context "attributes" do
    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"

    it { is_expected.to have_attribute(:initial_conversations).with_type(:array, :string) }
    it { is_expected.to have_attribute(:default_to_current_conversation).with_type(:boolean) }
    it { is_expected.to have_attribute(:max_selected_items).with_type(:integer) }
    it { is_expected.to have_attribute(:placeholder).with_type(:block_kit_plain_text) }
    it { is_expected.to have_attribute(:filter).with_type(:block_kit_conversation_filter) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:max_selected_items).allow_nil }
    it { is_expected.not_to allow_value(0).for(:max_selected_items).with_message("must be greater than 0") }
    it { is_expected.to validate_presence_of(:placeholder).allow_nil }
    it { is_expected.to validate_length_of(:placeholder).is_at_most(150).allow_nil }
  end
end
