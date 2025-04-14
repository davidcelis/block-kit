# frozen_string_literal: true

module BlockKit
  # Custom array class that maintains type constraints during mutation
  class TypedSet < Set
    attr_reader :item_type

    def initialize(item_type, enum = nil)
      # Only support scalar item types for now
      unless item_type.respond_to?(:type) && !item_type.type.start_with?("block_kit_")
        raise ArgumentError, "Only scalar item types are supported"
      end

      @item_type = item_type

      super(enum&.map { |item| item_type.cast(item) }&.compact)
    end

    # Override methods that modify the set to ensure type constraints.
    def add(item)
      super(item_type.cast(item)).tap(&:compact!)
    end
    alias_method :<<, :add

    def replace(other)
      super(other.map { |item| item_type.cast(item) }.compact)
    end

    def map!(&block)
      super { |item| item_type.cast(yield(item)) }.compact
    end

    def collect!(&block)
      super { |item| item_type.cast(yield(item)) }.compact
    end

    def merge(other)
      super(other.map { |item| item_type.cast(item) }).compact
    end

    def &(other)
      n = self.class.new(item_type)
      if other.is_a?(Set)
        each { |item| n.add(item) if other.include?(item) }
      else
        do_with_enum(other) { |item| n.add(item) if include?(item) }
      end

      n.compact
    end
    alias_method :intersection, :&

    def compact!
      delete(nil) { return nil }
      self
    end

    def compact
      dup.tap(&:compact!)
    end

    def inspect
      super.tap { |str| str.sub!("Set", "TypedSet[#{item_type.type}]") }
    end

    private

    def do_with_enum(enum, &block)
      if enum.respond_to?(:each_entry)
        enum.each_entry(&block) if block
      elsif enum.respond_to?(:each)
        enum.each(&block) if block
      else
        raise ArgumentError, "value must be enumerable"
      end
    end
  end
end
