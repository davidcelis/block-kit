# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Block
      self.type = :option_group

      include Concerns::HasOptions.new(limit: 100)

      attribute :label, Types::Block.of_type(Composition::PlainText)

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
