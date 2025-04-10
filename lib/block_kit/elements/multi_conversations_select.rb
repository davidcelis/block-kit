# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiConversationsSelect < MultiSelect
      self.type = :multi_conversations_select

      attribute :initial_conversations, Types::Array.of(:string)
      attribute :default_to_current_conversation, :boolean
      attribute :filter, Types::Block.of_type(Composition::ConversationFilter)

      def as_json(*)
        super.merge(
          initial_conversations: initial_conversations,
          default_to_current_conversation: default_to_current_conversation,
          filter: filter&.as_json
        ).compact
      end
    end
  end
end
