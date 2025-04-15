# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasInitialOptions
      def initial_options
        all_options&.select(&:initial?)
      end

      def as_json(*)
        super.merge(initial_options: initial_options&.map(&:as_json).presence).compact
      end

      private

      def all_options
        opts = Array(options)
        opts += Array(option_groups).flat_map(&:options) if respond_to?(:option_groups)
        opts
      end
    end
  end
end
