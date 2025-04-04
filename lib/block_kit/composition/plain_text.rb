# frozen_string_literal: true

require_relative "text"
require_relative "mrkdwn"

module BlockKit
  module Composition
    class PlainText < Text
      TYPE = "plain_text"

      attribute :emoji, :boolean

      def as_json(*)
        super.merge(emoji: emoji).compact
      end
    end
  end

  module Types
    class PlainTextBlock < TextBlock
      def type
        Composition::PlainText::TYPE
      end

      def cast(value)
        case value
        when Composition::PlainText
          value
        when Composition::Mrkdwn
          Composition::PlainText.new(text: value.text)
        when String, NilClass
          Composition::PlainText.new(text: value)
        when Hash
          Composition::PlainText.new(value.with_indifferent_access.slice(*Composition::PlainText.attribute_names))
        else
          raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::PlainText"
        end
      end
    end
  end
end
