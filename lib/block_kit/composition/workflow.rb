# frozen_string_literal: true

module BlockKit
  module Composition
    class Workflow < Base
      self.type = :workflow

      attribute :trigger, Types::Block.of_type(Composition::Trigger)
      validates :trigger, presence: true, "block_kit/validators/associated": true

      dsl_method :trigger

      def as_json(*)
        {trigger: trigger&.as_json}.compact
      end
    end
  end
end
