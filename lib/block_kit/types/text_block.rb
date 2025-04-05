# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    class TextBlock < ActiveModel::Type::Value
      include Singleton

      def type
        :text_block
      end

      def cast(value)
        case value
        when Composition::PlainText, Composition::Mrkdwn
          value
        when String
          MrkdwnBlock.instance.cast(value)
        when Hash
          if value.key?(:emoji) && value.key?(:verbatim)
            raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Text with both `emoji` and `verbatim` keys. This is too ambiguous."
          elsif value.key?(:emoji)
            PlainTextBlock.instance.cast(value)
          else
            MrkdwnBlock.instance.cast(value)
          end
        when NilClass
          nil
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
        when String
          Composition::PlainText.new(text: value)
        when Hash
          Composition::PlainText.new(value.with_indifferent_access.slice(*Composition::PlainText.attribute_names))
        when NilClass
          nil
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
        when String
          Composition::Mrkdwn.new(text: value)
        when Hash
          Composition::Mrkdwn.new(value.with_indifferent_access.slice(*Composition::Mrkdwn.attribute_names))
        when NilClass
          nil
        else
          raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Mrkdwn"
        end
      end
    end
  end
end
