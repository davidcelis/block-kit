# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class Text < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_text
      end

      def cast(value)
        case value
        when Composition::PlainText, Composition::Mrkdwn, NilClass
          value
        when Hash
          # Check for a `:type` key, otherwise prefer Mrkdwn over PlainText except
          # in the explicit case where only the `:text` and `:emoji` keys are provided
          type = value[:type]&.to_sym
          if type == :mrkdwn
            Mrkdwn.instance.cast(value)
          elsif type == :plain_text
            PlainText.instance.cast(value)
          elsif value.key?(:verbatim) || !value.key?(:emoji)
            Mrkdwn.instance.cast(value)
          else
            PlainText.instance.cast(value)
          end
        else
          Mrkdwn.instance.cast(value)
        end
      end
    end

    class PlainText < Text
      def block_class = Composition::PlainText

      def type
        :block_kit_plain_text
      end

      def cast(value)
        case value
        when block_class, NilClass
          value
        when Composition::Mrkdwn
          block_class.new(text: value.text)
        when Hash
          block_class.new(**value.with_indifferent_access.slice(*block_class.attribute_names).symbolize_keys)
        else
          block_class.new(text: value)
        end
      end
    end

    class Mrkdwn < Text
      def block_class = Composition::Mrkdwn

      def type
        :block_kit_mrkdwn
      end

      def cast(value)
        case value
        when block_class, NilClass
          value
        when Composition::PlainText
          block_class.new(text: value.text)
        when Hash
          block_class.new(**value.with_indifferent_access.slice(*block_class.attribute_names).symbolize_keys)
        else
          block_class.new(text: value)
        end
      end
    end
  end
end
