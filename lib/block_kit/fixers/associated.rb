# frozen_string_literal: true

module BlockKit
  module Fixers
    class Associated < Base
      def fix(model)
        model.validate
        errors = errors_for(model)

        return unless errors.any?

        associated = model.public_send(attribute)

        if associated.is_a?(Enumerable)
          error = errors.find { |e| e.type == :invalid }
          error.options[:invalid_values].each(&:fix_validation_errors) if error
        else
          associated&.fix_validation_errors
        end
      end
    end
  end
end
