# frozen_string_literal: true

module BlockKit
  module Fixers
    class Associated < Base
      def fix(model, fixing_dangerously: false)
        model.validate
        errors = errors_for(model)

        return unless errors.any?

        associated = model.public_send(attribute)

        if associated.is_a?(Enumerable)
          error = errors.find { |e| e.type == :invalid }
          return unless error

          error.options[:invalid_values].each do |associated|
            associated.fix_validation_errors(dangerous: fixing_dangerously)
          end
        else
          associated&.fix_validation_errors(dangerous: fixing_dangerously)
        end
      end
    end
  end
end
