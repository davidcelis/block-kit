# frozen_string_literal: true

module BlockKit
  module Layout
    class Base < BlockKit::Base
      attribute :block_id, :string
      validates :block_id, presence: true, length: {maximum: 255}, allow_nil: true
      fixes :block_id, null_value: {error_types: [:blank]}

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(Base)

        super
      end

      def as_json(*)
        super.merge(block_id: block_id).compact
      end
    end
  end
end
