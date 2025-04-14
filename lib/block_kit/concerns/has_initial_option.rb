# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasInitialOption
      extend ActiveSupport::Concern

      included do
        validate :only_one_initial_option
      end

      def initial_option
        if respond_to?(:option_groups)
          options&.find(&:initial?) || option_groups&.flat_map(&:options)&.find(&:initial?)
        else
          options&.find(&:initial?)
        end
      end

      def as_json(*)
        super.merge(initial_option: initial_option&.as_json).compact
      end

      private

      def only_one_initial_option
        if options.present? && options.count(&:initial?) > 1
          options.each_with_index do |option, index|
            errors.add("options[#{index}]", "can't be initial when other options are also as initial") if option.initial?
          end
        end

        if respond_to?(:option_groups) && option_groups.present?
          option_groups.each_with_index do |group, group_index|
            group.options.each_with_index do |option, option_index|
              errors.add("option_groups[#{group_index}].options[#{option_index}]", "can't be initial when other options are also as initial") if option.initial?
            end
          end
        end
      end
    end
  end
end
