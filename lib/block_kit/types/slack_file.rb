# frozen_string_literal: true

require "active_model"
require "singleton"

module BlockKit
  module Types
    class SlackFile < ActiveModel::Type::Value
      include Singleton

      def type
        :block_kit_slack_file
      end

      def cast(value)
        case value
        when Composition::SlackFile
          value
        when Hash
          Composition::SlackFile.new(**value.with_indifferent_access.slice(*Composition::SlackFile.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
