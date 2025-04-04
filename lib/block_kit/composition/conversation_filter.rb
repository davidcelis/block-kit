# frozen_string_literal: true

module BlockKit
  module Composition
    class ConversationFilter < Block
      VALID_INCLUDES = %w[im mpim public private].freeze

      attr_reader :include
      attribute :exclude_external_shared_channels, :boolean
      attribute :exclude_bot_users, :boolean

      validates :include, presence: {allow_nil: true}, "block_kit/validators/array_inclusion": {in: VALID_INCLUDES}

      def initialize(include: nil, **attributes)
        super(**attributes)

        self.include = include if include
      end

      def include=(value)
        @include = Array(value).map(&:to_s)
      end

      def as_json(*)
        {
          include: include,
          exclude_external_shared_channels: exclude_external_shared_channels,
          exclude_bot_users: exclude_bot_users
        }.compact
      end
    end
  end
end
