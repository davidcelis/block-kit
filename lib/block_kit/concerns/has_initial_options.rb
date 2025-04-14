# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasInitialOptions
      def initial_options
        if respond_to?(:option_groups)
          options&.select(&:initial?) || option_groups&.flat_map(&:options)&.select(&:initial?)
        else
          options&.select(&:initial?)
        end
      end

      def as_json(*)
        super.merge(initial_options: initial_options&.map(&:as_json).presence).compact
      end
    end
  end
end
