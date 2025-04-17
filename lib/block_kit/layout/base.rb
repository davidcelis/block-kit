# frozen_string_literal: true

module BlockKit
  module Layout
    class Base < BlockKit::Base
      MAX_BLOCK_ID_LENGTH = 255

      attribute :block_id, :string
      validates :block_id, presence: true, length: {maximum: MAX_BLOCK_ID_LENGTH}, allow_nil: true
      fixes :block_id, truncate: {maximum: MAX_BLOCK_ID_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

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
