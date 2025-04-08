# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Block
      attribute :label, Types::PlainText.instance
      attribute :options, Types::Array.of(Types::Option.instance)

      self.required_attributes = [:label, :options]

      validates :label, presence: true, length: {maximum: 75}
      validates :options, presence: true, length: {maximum: 100, message: "is too long (maximum is %{count} options)"}, "block_kit/validators/associated": true

      def as_json(*)
        {
          label: label&.as_json,
          options: options&.map(&:as_json)
        }
      end
    end
  end
end
