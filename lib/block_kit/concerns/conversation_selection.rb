# frozen_string_literal: true

module BlockKit
  module Concerns
    module ConversationSelection
      extend ActiveSupport::Concern

      included do
        attribute :default_to_current_conversation, :boolean
        attribute :filter, Types::Generic.of_type(Composition::ConversationFilter)

        validates :filter, "block_kit/validators/associated": true, allow_nil: true
        fixes :filter, associated: true

        dsl_method :filter
      end

      def as_json(*)
        super.merge(
          default_to_current_conversation: default_to_current_conversation,
          filter: filter&.as_json
        ).compact
      end
    end
  end
end
