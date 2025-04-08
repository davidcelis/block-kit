# frozen_string_literal: true

module BlockKit
  module Composition
    class Workflow < Block
      attribute :trigger, Types::Trigger.instance

      self.required_attributes = [:trigger]

      validates :trigger, presence: true

      def as_json(*)
        {trigger: trigger&.as_json}.compact
      end
    end
  end
end
