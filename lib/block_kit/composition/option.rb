# frozen_string_literal: true

module BlockKit
  module Composition
    class Option < Base
      MAX_TEXT_LENGTH = 75
      MAX_VALUE_LENGTH = 150
      MAX_DESCRIPTION_LENGTH = 75

      self.type = :option

      plain_text_attribute :text
      attribute :value, :string
      plain_text_attribute :description
      attribute :initial, :boolean

      include Concerns::PlainTextEmojiAssignment.new(:text, :description)

      validates :text, presence: true, length: {maximum: MAX_TEXT_LENGTH}
      fixes :text, truncate: {maximum: MAX_TEXT_LENGTH}

      validates :value, presence: true, length: {maximum: MAX_VALUE_LENGTH}

      validates :description, presence: true, length: {maximum: MAX_DESCRIPTION_LENGTH}, allow_nil: true
      fixes :description, truncate: {maximum: MAX_DESCRIPTION_LENGTH}, null_value: [:blank]

      def initial?
        !!initial
      end

      def as_json(*)
        {
          text: text&.as_json,
          value: value,
          description: description&.as_json
        }.compact
      end
    end
  end
end
