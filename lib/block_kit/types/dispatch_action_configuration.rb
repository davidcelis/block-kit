# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class DispatchActionConfiguration < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_dispatch_action_configuration
      end

      def cast(value)
        case value
        when Composition::DispatchActionConfiguration
          value
        when Hash
          Composition::DispatchActionConfiguration.new(**value.with_indifferent_access.slice(*Composition::DispatchActionConfiguration.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
