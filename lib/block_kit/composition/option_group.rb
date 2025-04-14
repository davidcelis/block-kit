# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Block
      self.type = :option_group

      include Concerns::HasOptions.new(limit: 100)

      plain_text_attribute :label
      validates :label, presence: true, length: {maximum: 75}

      dsl_method :options, as: :option, required_fields: [:text, :value], yields: false

      def as_json(*)
        {
          label: label&.as_json,
          options: options&.map(&:as_json)
        }
      end
    end
  end
end
