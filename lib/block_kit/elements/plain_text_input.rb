# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class PlainTextInput < Base
      self.type = :plain_text_input

      include Concerns::Dispatchable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      attribute :initial_value, :string
      attribute :min_length, :integer
      attribute :max_length, :integer
      attribute :multiline, :boolean

      validates :initial_value, presence: true, length: {minimum: ->(input) { input.min_length || 0 }, maximum: ->(input) { input.max_length || 3000 }}, allow_nil: true
      validates :multiline, inclusion: {in: [true, false]}, allow_nil: true
      validates :min_length, presence: true, numericality: {only_integer: true}, allow_nil: true
      validates :max_length, presence: true, numericality: {only_integer: true}, allow_nil: true
      validate :min_and_max_lengths_are_valid

      def as_json(*)
        super.merge(
          initial_value: initial_value,
          min_length: min_length,
          max_length: max_length,
          multiline: multiline
        ).compact
      end

      private

      # These validations are more complex than, say, the `number_input` validations due to
      # the fact that `min_length` can be 0 but `max_length` must be at least 1.
      def min_and_max_lengths_are_valid
        if min_length && max_length
          if min_length > max_length
            errors.add(:min_length, "must be less than or equal to max_length")
          elsif max_length < min_length
            errors.add(:max_length, "must be greater than or equal to min_length")
          end
        end

        if min_length && !min_length.in?(0..3000)
          errors.add(:min_length, "must be in 0..3000")
        end

        if max_length && !max_length.in?(1..3000)
          errors.add(:max_length, "must be in 1..3000")
        end
      end
    end
  end
end
