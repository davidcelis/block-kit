# frozen_string_literal: true

module BlockKit
  module Elements
    class IntegerInput < NumberInput
      attribute :min_value, :integer
      attribute :max_value, :integer
      attribute :initial_value, :integer

      validates :min_value, numericality: {only_integer: true, less_than_or_equal_to: :max_value}, allow_nil: true, if: :max_value
      validates :max_value, numericality: {only_integer: true, greater_than_or_equal_to: :min_value}, allow_nil: true, if: :min_value
      validates :initial_value, numericality: {only_integer: true, greater_than_or_equal_to: :min_value, less_than_or_equal_to: :max_value}, allow_nil: true

      def as_json(*)
        super.merge(
          is_decimal_allowed: false,
          initial_value: initial_value&.to_s,
          min_value: min_value&.to_s,
          max_value: max_value&.to_s
        ).compact
      end
    end
  end
end
