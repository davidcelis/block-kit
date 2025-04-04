# frozen_string_literal: true

require_relative "../block"

module BlockKit
  module Composition
    class PlainText < Block
      TYPE = "plain_text"

      attribute :text, :string
      attribute :emoji, :boolean

      delegate :length, :blank?, to: :text

      def as_json(*)
        super.merge(text: text, emoji: emoji).compact
      end
    end
  end

  module Types
    class PlainTextBlock < ActiveModel::Type::Value
      def cast(value)
        return value if value.is_a?(Composition::PlainText)

        case value
        when Hash
          Composition::PlainText.new(**value.symbolize_keys)
        else
          Composition::PlainText.new(text: value.to_s)
        end
      end
    end
  end
end
