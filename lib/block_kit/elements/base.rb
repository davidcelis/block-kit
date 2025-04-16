# frozen_string_literal: true

module BlockKit
  module Elements
    class Base < BlockKit::Base
      attribute :action_id, :string
      validates :action_id, presence: true, length: {maximum: 255}, allow_nil: true
      fixes :action_id, null_value: {error_types: [:blank]}

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(Base)

        super
      end

      def as_json(*)
        super.merge(action_id: action_id).compact
      end
    end
  end
end
