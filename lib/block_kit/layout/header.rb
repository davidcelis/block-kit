# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      MAX_LENGTH = 150

      self.type = :header

      attribute :text, Types::Block.of_type(Composition::PlainText)

      validates :text, presence: true, length: {maximum: MAX_LENGTH}

      def initialize(attributes = {})
        emoji = attributes.delete(:emoji)

        super

        text.emoji = emoji
      end

      def as_json(*)
        super.merge(text: text&.as_json)
      end

      def autofix!
        self.text = text.truncate(MAX_LENGTH) if text.length > MAX_LENGTH

        true
      end
    end
  end
end
