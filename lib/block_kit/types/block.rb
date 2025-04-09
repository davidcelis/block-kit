# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Provides a way to generate generic ActiveModel types for individual block types.
    # Most block types can simply be cast from an object of the same type or a Hash with
    # the object's attributes.
    class Block < ActiveModel::Type::Value
      class_attribute :instances, default: {}

      def self.new(block_class)
        instances[block_class.type] ||= super
      end

      class << self
        alias_method :of_type, :new
      end

      attr_reader :type

      def initialize(block_class)
        @block_class = block_class
        @type = :"block_kit_#{block_class.type}"
      end

      def cast(value)
        return value if value.is_a?(@block_class)

        case value
        when @block_class
          value
        when Hash
          @block_class.new(**value.with_indifferent_access.slice(*@block_class.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
