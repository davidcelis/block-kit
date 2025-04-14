# frozen_string_literal: true

module BlockKit
  module Composition
    class ConversationFilter < Block
      self.type = :conversation_filter

      VALID_INCLUDES = [
        IM = "im",
        MPIM = "mpim",
        PUBLIC = "public",
        PRIVATE = "private"
      ].freeze

      attribute :include, Types::Set.of(:string)
      attribute :exclude_external_shared_channels, :boolean
      attribute :exclude_bot_users, :boolean

      validates :include, presence: true, "block_kit/validators/array_inclusion": {in: VALID_INCLUDES, message: "contains invalid values: %{rejected_values}"}, allow_nil: true

      def as_json(*)
        {
          include: include&.to_a,
          exclude_external_shared_channels: exclude_external_shared_channels,
          exclude_bot_users: exclude_bot_users
        }.compact
      end
    end
  end
end
