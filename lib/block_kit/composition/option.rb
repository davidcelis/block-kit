# frozen_string_literal: true

module BlockKit
  module Composition
    class Option < Block
      self.type = :option

      attribute :text, Types::PlainText.instance
      attribute :value, :string
      attribute :description, Types::PlainText.instance
      attribute :initial, :boolean

      validates :text, presence: true, length: {maximum: 75}
      validates :value, presence: true, length: {maximum: 150}
      validates :description, presence: true, length: {maximum: 75}, allow_nil: true

      def initial?
        !!initial
      end

      def as_json(*)
        {
          text: text&.as_json,
          value: value,
          description: description&.as_json
        }.compact
      end
    end
  end
end
