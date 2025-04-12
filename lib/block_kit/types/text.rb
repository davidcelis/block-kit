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
      def type
        :block_kit_plain_text
      end

      def cast(value)
        case value
        when Composition::PlainText, NilClass
          value
        when Composition::Mrkdwn
          Composition::PlainText.new(text: value.text)
        when Hash
          Composition::PlainText.new(**value.with_indifferent_access.slice(*Composition::PlainText.attribute_names).symbolize_keys)
        else
          Composition::PlainText.new(text: value)
        end
      end
    end

    class Mrkdwn < Text
      def type
        :block_kit_mrkdwn
      end

      def cast(value)
        case value
        when Composition::Mrkdwn, NilClass
          value
        when Composition::PlainText
          Composition::Mrkdwn.new(text: value.text)
        when Hash
          Composition::Mrkdwn.new(**value.with_indifferent_access.slice(*Composition::Mrkdwn.attribute_names).symbolize_keys)
        else
          Composition::Mrkdwn.new(text: value)
        end
      end
    end
  end
end
