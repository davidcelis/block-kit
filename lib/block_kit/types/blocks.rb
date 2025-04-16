# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Provides a way to generate an ActiveModel type for multiple block types.
    class Blocks < ActiveModel::Type::Value
      attr_reader :block_classes, :block_types

      def initialize(*block_classes)
        @block_classes = block_classes
        @block_types = block_classes.map { |block_class| Types::Generic.of_type(block_class) }
      end

      def type
        :block_kit_block
      end

      def cast(value)
        case value
        when *@block_classes
          value
        when Hash
          value = value.with_indifferent_access
          type_name = value[:type]&.to_sym

          matching_type = @block_types.find do |type_class|
            type_class.respond_to?(:type) && type_class.type == :"block_kit_#{type_name}"
          end

          matching_type&.cast(value)
        end
      end
    end
  end
end
