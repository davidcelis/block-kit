# frozen_string_literal: true

module BlockKit
  module Elements
    class Base < Block
      attribute :action_id, :string

      validates :action_id, presence: true, length: {maximum: 255}, allow_nil: true

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and cannot be instantiated." if instance_of?(Base)

        super
      end

      def as_json(*)
        super.merge(action_id: action_id).compact
      end
    end
  end
end
