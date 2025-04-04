# frozen_string_literal: true

require_relative "../block"

module BlockKit
  module Composition
    class Text < Block
      attribute :text, :string
      delegate :length, :blank?, to: :text

      def as_json(*)
        super.merge(text: text)
      end
    end
  end

  module Types
    class TextBlock < ActiveModel::Type::Value
      def self.for_type(type)
        case type
        when Composition::PlainText::TYPE
          PlainTextBlock.new
        when Composition::MarkdownText::TYPE
          MarkdownTextBlock.new
        else
          raise ArgumentError, "Unknown type: #{type}"
        end
      end

      def cast(value)
        case value
        when Composition::PlainText, Composition::MarkdownText
          value
        when String, NilClass
          MrkdwnBlock.new.cast(value)
        when Hash
          # Default to `mrkdwn`, but if `emoji` is present, assume `plain_text`
          if value.key?(:emoji)
            PlainText.new.cast(value)
          else
            Mrkdwn.new.cast(value)
          end
        else
          raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Text"
        end
      end
    end
  end
end
