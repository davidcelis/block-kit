# frozen_string_literal: true

module BlockKit
  module Composition
    class PlainText
      TYPE = "plain_text"

      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :text, :string
      attribute :emoji, :boolean

      delegate :length, :blank?, to: :text

      def as_json(*)
        {
          type: TYPE,
          text: text,
          emoji: emoji
        }.compact
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
