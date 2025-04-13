# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class Option < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_option
      end

      def cast(value)
        case value
        when Composition::OverflowOption
          Composition::Option.new(text: value.text, value: value.value)
        when Composition::Option
          value
        when Hash
          Composition::Option.new(**value.with_indifferent_access.slice(*Composition::Option.attribute_names).symbolize_keys)
        end
      end
    end

    class OverflowOption < Option
      def type
        :block_kit_overflow_option
      end

      def cast(value)
        case value
        when Composition::OverflowOption
          value
        when Composition::Option
          Composition::OverflowOption.new(text: value.text, value: value.value)
        when Hash
          Composition::OverflowOption.new(**value.with_indifferent_access.slice(*Composition::OverflowOption.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
