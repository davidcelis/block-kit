# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class Trigger < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_trigger
      end

      def cast(value)
        case value
        when Composition::Trigger
          value
        when Hash
          attribute_names = Composition::Trigger.attribute_names + ["customizable_input_parameters"]
          Composition::Trigger.new(**value.with_indifferent_access.slice(*attribute_names).symbolize_keys)
        end
      end
    end
  end
end
