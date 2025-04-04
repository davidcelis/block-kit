# frozen_string_literal: true

module BlockKit
  module Types
    class TextBlock < ActiveModel::Type::Value
      def type
        :text_block
      end

      def cast(value)
        case value
        when Composition::PlainText, Composition::Mrkdwn
          value
        when String, NilClass
          MrkdwnBlock.new.cast(value)
        when Hash
          if value.key?(:emoji) && value.key?(:verbatim)
            raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Text with both `emoji` and `verbatim` keys. This is too ambiguous."
          elsif value.key?(:emoji)
            PlainTextBlock.new.cast(value)
          else
            MrkdwnBlock.new.cast(value)
          end
        else
          raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Text"
        end
      end
    end

    class PlainTextBlock < TextBlock
      def type
        :plain_text_block
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

    class MrkdwnBlock < TextBlock
      def type
        :mrkdwn_block
      end

      def cast(value)
        case value
        when Composition::Mrkdwn
          value
        when Composition::PlainText
          Composition::Mrkdwn.new(text: value.text)
        when String, NilClass
          Composition::Mrkdwn.new(text: value)
        when Hash
          Composition::Mrkdwn.new(value.with_indifferent_access.slice(*Composition::Mrkdwn.attribute_names))
        else
          raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Mrkdwn"
        end
      end
    end
  end
end
