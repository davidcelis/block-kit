# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class Option < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_option
      end

      def cast(value)
        case value
        when Composition::Option
          value
        when Hash
          Composition::Option.new(value.with_indifferent_access.slice(*Composition::Option.attribute_names))
        end
      end
    end
  end
end
