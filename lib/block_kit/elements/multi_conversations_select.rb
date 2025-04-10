# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiConversationsSelect < MultiSelect
      self.type = :multi_conversations_select

      include Concerns::ConversationSelection

      attribute :initial_conversations, Types::Array.of(:string)

      def as_json(*)
        super.merge(initial_conversations: initial_conversations).compact
      end
    end
  end
end
