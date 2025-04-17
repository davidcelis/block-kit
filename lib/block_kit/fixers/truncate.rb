# frozen_string_literal: true

module BlockKit
  module Fixers
    class Truncate < Base
      def initialize(attribute:, **options)
        super

        @maximum = options.delete(:maximum)
        @omission = options.delete(:omission)
      end

      def fix(model, fixing_dangerously: false)
        return if dangerous? && !fixing_dangerously

        model.validate
        errors = errors_for(model)

        return unless errors.any? { |e| e.type == :too_long }

        value = model.attributes[attribute.to_s]
        maximum = @maximum.call(model) if @maximum.is_a?(Proc)
        maximum ||= @maximum

        new_value = if value.is_a?(Enumerable)
          value.first(maximum)
        else
          value.truncate(maximum, omission: @omission)
        end

        model.assign_attributes(attribute => new_value)
      end
    end
  end
end
