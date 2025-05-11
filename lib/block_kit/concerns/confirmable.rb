# frozen_string_literal: true

module BlockKit
  module Concerns
    module Confirmable
      extend ActiveSupport::Concern

      included do
        attribute :confirm, Types::Generic.of_type(Composition::ConfirmationDialog)
        validates :confirm, "block_kit/validators/associated": true, allow_nil: true
        fixes :confirm, associated: true

        alias_attribute :confirmation_dialog, :confirm

        dsl_method :confirm, required_fields: [:title, :text, :confirm, :deny], yields: false
      end

      def as_json(*)
        super.merge(confirm: confirm&.as_json).compact
      end
    end
  end
end
