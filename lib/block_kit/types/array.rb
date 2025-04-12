# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Allows declaring ActiveModel attributes that are arrays of specific types,
    # powered by an internal TypedArray class that enforces type constraints on
    # array elements any time the array is modified.
    class Array < ActiveModel::Type::Value
      attr_reader :item_type

      def self.of(item_type)
        new(item_type)
      end

      def initialize(item_type)
        item_type = ActiveModel::Type.lookup(item_type) if item_type.is_a?(Symbol)
        item_type = Types::Block.of_type(item_type) if item_type.is_a?(Class) && item_type < BlockKit::Block

        @item_type = item_type
      end

      def type
        :array
      end

      def cast(value)
        # binding.irb if caller.join.include?("spec/block_kit/layout/rich_text/preformatted_spec.rb")
        return nil if value.nil?

        TypedArray.new(item_type, Array(value))
      end

      def serialize(value)
        return nil if value.nil?

        cast(value)
      end

      def changed_in_place?(raw_old_value, new_value)
        cast(raw_old_value) != cast(new_value)
      end
    end
  end
end
