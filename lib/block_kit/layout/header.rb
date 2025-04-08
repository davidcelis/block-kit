# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      TYPE = "header"

      attribute :text, Types::PlainText.instance

      self.required_attributes = [:text]

      validates :text, presence: true, length: {maximum: 150}

      def initialize(attributes = {})
        emoji = attributes.delete(:emoji)

        super

        text.emoji = emoji
      end

      def as_json(*)
        super.merge(text: text&.as_json)
      end
    end
  end
end
