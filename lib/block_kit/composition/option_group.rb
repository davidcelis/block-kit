# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Base
      self.type = :option_group

      MAX_LABEL_LENGTH = 75
      MAX_OPTIONS = 100

      include Concerns::HasOptions.new(limit: MAX_OPTIONS)

      plain_text_attribute :label
      validates :label, presence: true, length: {maximum: MAX_LABEL_LENGTH}
      fixes :label, truncate: {maximum: MAX_LABEL_LENGTH}

      dsl_method :options, as: :option, required_fields: [:text, :value], yields: false

      def as_json(*)
        super().except(:type).merge(
          label: label&.as_json,
          options: options&.map(&:as_json)
        ).compact
      end
    end
  end
end
