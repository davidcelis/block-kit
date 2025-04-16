# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiConversationsSelect < MultiSelect
      self.type = :multi_conversations_select

      include Concerns::ConversationSelection

      attribute :initial_conversations, Types::Set.of(:string)
      validate :initial_conversations_are_all_present
      fix :remove_blank_initial_conversations

      def as_json(*)
        super.merge(initial_conversations: initial_conversations&.to_a).compact
      end

      private

      def initial_conversations_are_all_present
        if Array(initial_conversations).any?(&:blank?)
          errors.add(:initial_conversations, "must not contain blank values")
        end
      end

      def remove_blank_initial_conversations
        return unless initial_conversations.present?

        initial_conversations.reject!(&:blank?)
      end
    end
  end
end
