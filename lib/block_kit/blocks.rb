module BlockKit
  class Blocks
    attr_reader :blocks

    def initialize
      @blocks = []

      yield self if block_given?
    end

    def divider(block_id: nil)
      append(Layout::Divider.new(block_id: block_id))
    end

    def append(block)
      @blocks << block

      self
    end

    def as_json(*)
      @blocks.map(&:as_json)
    end
  end
end
