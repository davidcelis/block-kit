# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Allows declaring ActiveModel attributes that are Sets of specific types,
    # powered by an internal TypedSet class that enforces type constraints on
    # set members any time the set is modified or any time set operations are
    # performed against other collections.
    class Set < Array
      attr_reader :item_type

      def type
        :set
      end

      def cast(value)
        return nil if value.nil?

        TypedSet.new(item_type, Array(value))
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
