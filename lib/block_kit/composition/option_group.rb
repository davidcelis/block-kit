# frozen_string_literal: true

module BlockKit
  module Composition
    class OptionGroup < Block
      self.type = :option_group

      include Concerns::HasOptions.new(limit: 100)

      plain_text_attribute :label
      validates :label, presence: true, length: {maximum: 75}

      def option(text:, value:, description: nil, initial: nil, emoji: nil)
        options << Composition::Option.new(text: text, value: value, description: description, initial: initial, emoji: emoji)

        self
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
