# frozen_string_literal: true

module BlockKit
  module Concerns
    module Dispatchable
      extend ActiveSupport::Concern

      included do
        attribute :dispatch_action_config, Types::Block.of_type(Composition::DispatchActionConfig)
        alias_attribute :dispatch_action_configuration, :dispatch_action_config

        validates :dispatch_action_config, presence: true, "block_kit/validators/associated": true, allow_nil: true

        dsl_method :dispatch_action_config
      end

      def as_json(*)
        super.merge(dispatch_action_config: dispatch_action_config&.as_json).compact
      end
    end
  end
end
