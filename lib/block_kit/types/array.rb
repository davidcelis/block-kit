# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Allows declaring ActiveModel attributes that are arrays of specific types,
    # powered by an internal TypedArray class that enforces type constraints on
    # array elements any time the array is modified.
    class Array < ActiveModel::Type::Value
      attr_reader :item_types

      def self.of(*item_types)
        new(*item_types)
      end

      def initialize(*item_types)
        if item_types.size > 1 && item_types.any? { |type| !(type.is_a?(Class) && type < BlockKit::Block) }
          raise ArgumentError, "Multiple types are only supported for Block classes"
        end

        @item_types = item_types.map do |item_type|
          if item_type.is_a?(Class) && item_type < BlockKit::Block
            Types::Block.of_type(item_type)
          elsif item_type.is_a?(Symbol)
            ActiveModel::Type.lookup(item_type)
          else
            item_type
          end
        end
      end

      def type
        :array
      end

      def cast(value)
        return nil if value.nil?

        TypedArray.new(@item_types, Array(value))
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
        def initialize(item_types, *args)
          @item_types = item_types

          # Array.new supports three different argument signatures:
          #
          # 1. Array.new(size = nil, object = nil): creates an array of the given size
          #    filled with the given object
          # 2. Array.new(array): creates a new array that is a copy of the given array
          # 3. Array.new(size, &block): creates a new array of the given size, passing
          #    each index to the block and using the block's return value to fill the array
          #
          # We need to handle all three cases, as they all result in filling the array.
          # Calling `super(*)` and then `map!` does not work, as it does not end up
          # modifying the array for some reason.
          if args.size == 1 && args.first.is_a?(::Array)
            super(args.first.map { |item| cast_item(item) }.compact)
          elsif args.size == 2
            super(args[0], cast_item(item)).compact!
          elsif args.size == 1 && block_given?
            super(args[0]) { |index| cast_item(yield(index)) }
          end
        end

        # Override methods that modify the array to ensure type constraints
        def <<(item)
          super(cast_item(item)).tap { |_| compact! }
        end

        def push(*items)
          super(*items.map { |item| cast_item(item) }.compact)
        end

        def unshift(*items)
          super(*items.map { |item| cast_item(item) }.compact)
        end

        def insert(index, *items)
          super(index, *items.map { |item| cast_item(item) }.compact)
        end

        def []=(position, *args)
          if args.length == 0
            # array[1] = value
            super(position, cast_item(position))
          elsif args.length == 1
            if position.is_a?(Range)
              # array[1..3] = [x, y, z]
              value = args[0]
              if value.is_a?(::Array)
                super(position, value.map { |item| cast_item(item) })
              else
                super(position, cast_item(value))
              end
            else
              # array[1] = value
              super(position, cast_item(args[0]))
            end
          else
            # array[1, 2] = [x, y]
            length, value = args
            if value.is_a?(::Array)
              super(position, length, value.map { |item| cast_item(item) })
            else
              super(position, length, cast_item(value))
            end
          end

          compact!
        end

        def replace(other_array)
          super(other_array.map { |item| cast_item(item) }.compact)
        end

        def fill(*args, &block)
          if block_given?
            # If a block is given, we need to intercept its results
            modified_block = proc { |*block_args| cast_item(yield(*block_args)) }
            super(*args, &modified_block)
          elsif args.size > 0
            # No block, so the last argument is the value to fill with
            value = args.pop
            super(*args, cast_item(value))
          else
            super
          end
        end

        def map!(&block)
          super { |item| cast_item(yield(item)) }.compact
        end

        def collect!(&block)
          super { |item| cast_item(yield(item)) }.compact
        end

        def concat(other_array)
          super(other_array.map { |item| cast_item(item) }).compact
        end

        private

        def cast_item(item)
          if @item_types.size == 1
            @item_types.first.cast(item)
          elsif item.is_a?(BlockKit::Block)
            matching_type = @item_types.find { |type| item.is_a?(type.block_class) }

            matching_type&.cast(item)
          elsif item.is_a?(Hash)
            item = item.with_indifferent_access

            # If the item is a Hash, try to determine the correct type based on the
            # `:type` key that most blocks have.
            type_name = item[:type]&.to_sym

            matching_type = @item_types.find do |type_class|
              type_class.respond_to?(:type) && type_class.type == :"block_kit_#{type_name}"
            end

            matching_type&.cast(item)
          end
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
