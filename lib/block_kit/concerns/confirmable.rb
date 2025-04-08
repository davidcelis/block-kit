# frozen_string_literal: true

module BlockKit
  module Concerns
    module Confirmable
      extend ActiveSupport::Concern

      included do
        attribute :confirm, Types::ConfirmationDialog.instance

        validates :confirm, "block_kit/validators/associated": true, allow_nil: true
      end

      def as_json(*)
        super.merge(confirm: confirm&.as_json).compact
      end
    end
  end
end
