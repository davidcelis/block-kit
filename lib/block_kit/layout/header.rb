# frozen_string_literal: true

require "active_model"
require_relative "base"
require_relative "../composition/plain_text"

module BlockKit
  module Layout
    class Header < Base
      TYPE = "header"

      attribute :text, Types::PlainTextBlock.new

      validates :text, presence: true, length: {maximum: 150, allow_blank: true}

      def initialize(emoji: nil, **attributes)
        super(**attributes)

        text.emoji = emoji
      end

      def as_json(*)
        super.merge(text: text.as_json)
      end
    end
  end
end
