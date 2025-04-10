# frozen_string_literal: true

module BlockKit
  module Elements
    class DecimalInput < NumberInput
      attribute :min_value, :decimal
      attribute :max_value, :decimal
      attribute :initial_value, :decimal

      validates :min_value, numericality: {less_than_or_equal_to: :max_value}, allow_nil: true, if: :max_value
      validates :max_value, numericality: {greater_than_or_equal_to: :min_value}, allow_nil: true, if: :min_value
      validates :initial_value, numericality: {greater_than_or_equal_to: :min_value, less_than_or_equal_to: :max_value}, allow_nil: true

      def as_json(*)
        super.merge(
          is_decimal_allowed: true,
          initial_value: initial_value&.to_digits,
          min_value: min_value&.to_digits,
          max_value: max_value&.to_digits
        ).compact
      end
    end
  end
end
