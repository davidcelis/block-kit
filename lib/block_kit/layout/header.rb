# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      self.type = :header

      attribute :text, Types::Block.of_type(Composition::PlainText)

      validates :text, presence: true, length: {maximum: 150}

      def initialize(attributes = {})
        emoji = attributes.delete(:emoji)

        super

        unless emoji.nil?
          self.text ||= Composition::PlainText.new
          self.text.emoji = emoji
        end
      end

      def as_json(*)
        super.merge(text: text&.as_json)
      end
    end
  end
end
