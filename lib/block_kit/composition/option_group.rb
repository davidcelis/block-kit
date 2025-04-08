# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Block
      attribute :label, Types::PlainText.instance
      attr_reader :options

      self.required_attributes = [:label]

      validates :label, presence: true, length: {maximum: 75}
      validates :options, presence: true, length: {maximum: 100, message: "is too long (maximum is %{count} options)"}, "block_kit/validators/associated": true

      def initialize(attributes = {})
        options = attributes.delete(:options) { [] }

        super

        self.options = options
      end

      def options=(items)
        @options = if items
          Array(items).map { |item| Types::Option.instance.cast(item) }.compact
        end
      end

      def as_json(*)
        {
          label: label&.as_json,
          options: options&.map(&:as_json)
        }
      end
    end
  end
end
