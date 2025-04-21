# frozen_string_literal: true

module BlockKit
  module Elements
    class Base < BlockKit::Base
      MAX_ACTION_ID_LENGTH = 255

      attribute :action_id, :string
      validates :action_id, presence: true, length: {maximum: MAX_ACTION_ID_LENGTH}, allow_nil: true
      fixes :action_id, truncate: {maximum: MAX_ACTION_ID_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

      def self.inherited(subclass)
        subclass.attribute_fixers = attribute_fixers.deep_dup
      end

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
