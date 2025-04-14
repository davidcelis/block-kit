# frozen_string_literal: true

module BlockKit
  module Elements
    class WorkflowButton < BaseButton
      self.type = :workflow_button

      attribute :workflow, Types::Block.of_type(Composition::Workflow)
      validates :workflow, presence: true, "block_kit/validators/associated": true

      dsl_method :workflow

      def as_json(*)
        super.merge(workflow: workflow&.as_json).compact
      end
    end
  end
end
