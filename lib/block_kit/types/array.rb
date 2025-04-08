# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Allows declaring ActiveModel attributes that are arrays of a specific type,
    # powered by an internal TypedArray class that enforces type constraints on
    # array elements any time the array is modified.
    class Array < ActiveModel::Type::Value
      attr_reader :item_type

      class_attribute :instances, default: {}

      def self.new(item_type)
        instances[item_type] ||= super
      end

      class << self
        alias_method :of, :new
      end

      def initialize(item_type)
        item_type = ActiveModel::Type.lookup(item_type) if item_type.is_a?(Symbol)

        @item_type = item_type
      end

      def type
        :array
      end

      def cast(value)
        return nil if value.nil?

        array = Array(value)

        TypedArray.new(@item_type, array.map { |item| @item_type.cast(item) }.compact)
      end

      def serialize(value)
        return nil if value.nil?
        cast(value)
      end

      def changed_in_place?(raw_old_value, new_value)
        cast(raw_old_value) != cast(new_value)
      end

      # Custom array class that maintains type constraints during mutation
      class TypedArray < ::Array
        attr_reader :item_type

        def initialize(item_type, *args)
          @item_type = item_type

          super(*args)
        end

        # Override methods that modify the array to ensure type constraints
        def <<(item)
          super(item_type.cast(item))
        end

        def push(*items)
          super(*items.map { |item| item_type.cast(item) })
        end

        def unshift(*items)
          super(*items.map { |item| item_type.cast(item) })
        end

        def insert(index, *items)
          super(index, *items.map { |item| item_type.cast(item) })
        end

        def []=(*args, value)
          if args.size == 1 && args[0].is_a?(Range)
            # For range assignments like array[1..3] = [x, y, z]
            if value.is_a?(::Array)
              super(args[0], value.map { |item| item_type.cast(item) })
            else
              super(args[0], item_type.cast(value))
            end
          elsif args.size == 2
            # For index and length assignments like array[1, 2] = [x, y]
            if value.is_a?(::Array)
              super(args[0], args[1], value.map { |item| item_type.cast(item) })
            else
              super(args[0], args[1], item_type.cast(value))
            end
          else
            # For single index assignments like array[1] = x
            super(args[0], item_type.cast(value))
          end
        end

        def replace(other_array)
          super(other_array.map { |item| item_type.cast(item) })
        end

        def fill(*args, &block)
          if block_given?
            # If a block is given, we need to intercept its results
            modified_block = proc { |*block_args| item_type.cast(yield(*block_args)) }
            super(*args, &modified_block)
          elsif args.size > 0
            # No block, so the last argument is the value to fill with
            value = args.pop
            super(*args, item_type.cast(value))
          else
            super
          end
        end

        def map!(&block)
          super { |item| item_type.cast(yield(item)) }
        end

        def collect!(&block)
          super { |item| item_type.cast(yield(item)) }
        end

        def concat(other_array)
          super(other_array.map { |item| item_type.cast(item) })
        end

        # Note: methods that return new arrays (like `+`, `&`, `|`, etc.) are not
        # overridden, as it's not necessary to enforce type constraints on the
        # resulting array. If the resulting array is later assigned back to the
        # attribute backing the original array, type constraints will be enforced
        # at that time.
      end
    end
  end
end
