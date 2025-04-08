# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class ConfirmationDialog < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_confirmation_dialog
      end

      def cast(value)
        case value
        when Composition::ConfirmationDialog
          value
        when Hash
          Composition::ConfirmationDialog.new(**value.with_indifferent_access.slice(*Composition::ConfirmationDialog.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
