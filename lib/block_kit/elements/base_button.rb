# frozen_string_literal: true

module BlockKit
  module Elements
    class BaseButton < Base
      self.type = :button

      MAX_TEXT_LENGTH = 75
      MAX_ACCESSIBILITY_LABEL_LENGTH = 75
      VALID_STYLES = [
        PRIMARY = "primary",
        DANGER = "danger"
      ].freeze

      plain_text_attribute :text
      attribute :style, :string
      attribute :accessibility_label, :string

      include Concerns::PlainTextEmojiAssignment.new(:text)

      validates :text, presence: true, length: {maximum: MAX_TEXT_LENGTH}
      fixes :text, truncate: {maximum: MAX_TEXT_LENGTH}

      validates :style, presence: true, inclusion: {in: VALID_STYLES}, allow_nil: true
      fixes :style, null_value: {error_types: [:inclusion]}

      validates :accessibility_label, presence: true, length: {maximum: MAX_ACCESSIBILITY_LABEL_LENGTH}, allow_nil: true
      fixes :accessibility_label, truncate: {maximum: MAX_ACCESSIBILITY_LABEL_LENGTH}, null_value: {error_types: [:blank]}

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(BaseButton)

        super
      end

      def as_json(*)
        super.merge(
          text: text&.as_json,
          style: style,
          accessibility_label: accessibility_label
        ).compact
      end
    end
  end
end
