# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Block
      include Concerns::HasOptions.with_limit(100)

      attribute :label, Types::PlainText.instance

      validates :label, presence: true, length: {maximum: 75}

      def as_json(*)
        {
          label: label&.as_json,
          options: options&.map(&:as_json)
        }
      end
    end
  end
end
