# frozen_string_literal: true

require "active_model"
require_relative "../composition/plain_text"

module BlockKit
  module Layout
    class Header
      TYPE = "header"

      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attribute :block_id, :string
      attribute :text, Types::PlainTextBlock.new

      validates :block_id, allow_blank: true, length: {maximum: 255}
      validates :text, presence: true, length: {maximum: 150}

      def initialize(emoji: nil, **attributes)
        super(**attributes)

        text.emoji = emoji
      end

      def as_json(*)
        {
          text: text.as_json,
          type: TYPE,
          block_id: block_id
        }.compact
      end
    end
  end
end
