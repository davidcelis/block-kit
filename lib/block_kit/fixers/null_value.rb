# frozen_string_literal: true

require "active_support/core_ext/object/inclusion"

module BlockKit
  module Fixers
    class NullValue < Base
      def initialize(attribute:, **options)
        super

        @error_types = options.delete(:error_types) { [:blank] }
      end

      def fix(model, fixing_dangerously: false)
        return if dangerous? && !fixing_dangerously

        model.validate
        errors = errors_for(model)

        return unless errors.any? { |e| error_types.include?(e.type) }

        value = model.attributes[attribute.to_s]

        # First, check if the attribute is an array and if we have an `inclusion` error.
        # If so, we'll remove invalid values from the array. If the new value is empty
        # and this fixer is configured to handle `blank` errors, we'll nullify it.
        if value.is_a?(Enumerable) && (error = errors.find { |e| e.type == :inclusion })
          new_value = value - error.options[:invalid_values]
          new_value = new_value.presence if error_types.include?(:blank)

          model.assign_attributes(attribute => new_value)
        else
          model.assign_attributes(attribute => nil)
        end
      end

      private

      attr_reader :error_types
    end
  end
end
