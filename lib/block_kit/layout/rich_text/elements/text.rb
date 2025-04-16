# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class RichText::Elements::Text < BlockKit::Base
      self.type = :text

      attribute :text, :string
      attribute :style, Types::Block.of_type(RichText::Elements::TextStyle)

      validates :text, presence: true

      def as_json(*)
        super.merge(
          text: text,
          style: style&.as_json
        ).compact
      end
    end
  end
end
