# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      TYPE = "header"

      attribute :text, Types::PlainText.instance

      validates :text, presence: true, length: {maximum: 150}

      def initialize(emoji: nil, **attributes)
        super(**attributes)

        self.text ||= Composition::PlainText.new

        text.emoji = emoji
      end

      def as_json(*)
        super.merge(text: text.as_json)
      end
    end
  end
end
