# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasInitialOption
      def initial_option
        all_options&.reverse&.find(&:initial?) # rubocop:disable Style/ReverseFind -- `rfind` is only available as of Ruby 4.0+
      end

      def as_json(*)
        super.merge(initial_option: initial_option&.as_json).compact
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
