# frozen_string_literal: true

module BlockKit
  module Composition
    class ConversationFilter < Block
      VALID_INCLUDES = [
        IM = "im",
        MPIM = "mpim",
        PUBLIC = "public",
        PRIVATE = "private"
      ].freeze

      attr_reader :include
      attribute :exclude_external_shared_channels, :boolean
      attribute :exclude_bot_users, :boolean

      validates :include, presence: true, "block_kit/validators/array_inclusion": {in: VALID_INCLUDES}, allow_nil: true

      def initialize(include: nil, **attributes)
        super(**attributes)

        self.include = include
      end

      def include=(values)
        @include = if values
          Array(values).map(&:to_s)
        end
      end

      def as_json(*)
        {
          include: include&.uniq,
          exclude_external_shared_channels: exclude_external_shared_channels,
          exclude_bot_users: exclude_bot_users
        }.compact
      end
    end
  end
end
