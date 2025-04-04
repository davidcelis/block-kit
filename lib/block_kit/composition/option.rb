# frozen_string_literal: true

module BlockKit
  module Composition
    class Option < Block
      attribute :text, Types::PlainTextBlock.instance
      attribute :value, :string
      attribute :description, Types::PlainTextBlock.instance

      validates :text, presence: true, length: {maximum: 75, allow_blank: true}
      validates :value, presence: true, length: {maximum: 150, allow_blank: true}
      validates :description, length: {maximum: 75, allow_blank: true}

      def as_json(*)
        {
          text: text.as_json,
          value: value,
          description: description&.as_json
        }.compact
      end
    end
  end
end
