# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class InputParameter < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_input_parameter
      end

      def cast(value)
        case value
        when Composition::InputParameter
          value
        when Hash
          Composition::InputParameter.new(**value.with_indifferent_access.slice(*Composition::InputParameter.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
