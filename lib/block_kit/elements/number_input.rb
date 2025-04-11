# frozen_string_literal: true

module BlockKit
  module Elements
    class NumberInput < Base
      self.type = :number_input

      include Concerns::Dispatchable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      attribute :is_decimal_allowed, :boolean
      attribute :min_value, :decimal
      attribute :max_value, :decimal
      attribute :initial_value, :decimal

      validates :min_value, numericality: {less_than_or_equal_to: :max_value}, allow_nil: true, if: :max_value
      validates :max_value, numericality: {greater_than_or_equal_to: :min_value}, allow_nil: true, if: :min_value
      validates :initial_value, numericality: {greater_than_or_equal_to: :min_value, less_than_or_equal_to: :max_value}, allow_nil: true

      def is_decimal_allowed?
        !!is_decimal_allowed
      end
      alias_method :decimal_allowed?, :is_decimal_allowed?

      def min_value
        decimal_allowed? ? super : super&.to_i
      end

      def max_value
        decimal_allowed? ? super : super&.to_i
      end

      def initial_value
        decimal_allowed? ? super : super&.to_i
      end

      def as_json(*)
        super.merge(
          is_decimal_allowed: is_decimal_allowed,
          initial_value: initial_value.respond_to?(:to_digits) ? initial_value.to_digits : initial_value&.to_i,
          min_value: min_value.respond_to?(:to_digits) ? min_value.to_digits : min_value&.to_i,
          max_value: max_value.respond_to?(:to_digits) ? max_value.to_digits : max_value&.to_i
        ).compact
      end
    end
  end
end
