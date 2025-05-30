# frozen_string_literal: true

module BlockKit
  # Custom array class that maintains type constraints during mutation
  class TypedArray < ::Array
    attr_reader :item_type

    def initialize(item_type, *args)
      @item_type = item_type

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
        super(args.first.map { |item| item_type.cast(item) }.compact)
      elsif args.size == 2
        super(args[0], item_type.cast(item)).compact!
      elsif args.size == 1 && block_given?
        super(args[0]) { |index| item_type.cast(yield(index)) }
      end
    end

    # Override methods that modify the array to ensure type constraints
    def <<(item)
      super(item_type.cast(item)).tap(&:compact!)
    end

    def push(*items)
      super(*items.map { |item| item_type.cast(item) }.compact)
    end

    def unshift(*items)
      super(*items.map { |item| item_type.cast(item) }.compact)
    end

    def insert(index, *items)
      super(index, *items.map { |item| item_type.cast(item) }.compact)
    end

    def []=(position, *args)
      if args.length == 0
        # array[1] = value
        super(position, item_type.cast(position))
      elsif args.length == 1
        if position.is_a?(Range)
          # array[1..3] = [x, y, z]
          value = args[0]
          if value.is_a?(::Array)
            super(position, value.map { |item| item_type.cast(item) })
          else
            super(position, item_type.cast(value))
          end
        else
          # array[1] = value
          super(position, item_type.cast(args[0]))
        end
      else
        # array[1, 2] = [x, y]
        length, value = args
        if value.is_a?(::Array)
          super(position, length, value.map { |item| item_type.cast(item) })
        else
          super(position, length, item_type.cast(value))
        end
      end

      compact!
    end

    def replace(other_array)
      super(other_array.map { |item| item_type.cast(item) }.compact)
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
      super { |item| item_type.cast(yield(item)) }.compact
    end

    def collect!(&block)
      super { |item| item_type.cast(yield(item)) }.compact
    end

    def concat(other_array)
      super(other_array.map { |item| item_type.cast(item) }).compact
    end

    # Note: methods that return new arrays (like `+`, `&`, `|`, etc.) are not
    # overridden, as it's not necessary to enforce type constraints on the
    # resulting array. If the resulting array is later assigned back to the
    # attribute backing the original array, type constraints will be enforced
    # at that time.
  end
end
