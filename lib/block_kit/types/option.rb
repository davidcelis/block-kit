# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class Option < ActiveModel::Type::Value
      def block_class = Composition::Option

      include Singleton

      def type
        :block_kit_option
      end

      def cast(value)
        case value
        when Composition::OverflowOption
          block_class.new(text: value.text, value: value.value)
        when block_class
          value
        when Hash
          block_class.new(**value.with_indifferent_access.slice(*block_class.attribute_names).symbolize_keys)
        end
      end
    end

    class OverflowOption < Option
      def block_class = Composition::OverflowOption

      def type
        :block_kit_overflow_option
      end

      def cast(value)
        case value
        when block_class
          value
        when Composition::Option
          block_class.new(text: value.text, value: value.value)
        when Hash
          block_class.new(**value.with_indifferent_access.slice(*block_class.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
