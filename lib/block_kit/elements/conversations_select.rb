# frozen_string_literal: true

module BlockKit
  module Elements
    class ConversationsSelect < Select
      self.type = :conversations_select

      include Concerns::ConversationSelection

      attribute :initial_conversation, :string
      attribute :response_url_enabled, :boolean

      def as_json(*)
        super.merge(
          initial_conversation: initial_conversation,
          response_url_enabled: response_url_enabled
        ).compact
      end
    end
  end
end
