# frozen_string_literal: true

module BlockKit
  module Composition
    class ConfirmationDialog < Block
      MAX_TITLE_TEXT_LENGTH = 100
      MAX_TEXT_LENGTH = 300
      MAX_BUTTON_TEXT_LENGTH = 30
      VALID_STYLES = [
        PRIMARY = "primary",
        DANGER = "danger"
      ].freeze

      self.type = :confirmation_dialog

      plain_text_attribute :title
      plain_text_attribute :text
      plain_text_attribute :confirm
      plain_text_attribute :deny
      attribute :style, :string

      validates :title, presence: true, length: {maximum: MAX_TITLE_TEXT_LENGTH}
      fixes :title, truncate: {maximum: MAX_TITLE_TEXT_LENGTH}

      validates :text, presence: true, length: {maximum: MAX_TEXT_LENGTH}
      fixes :text, truncate: {maximum: MAX_TEXT_LENGTH}

      validates :confirm, presence: true, length: {maximum: MAX_BUTTON_TEXT_LENGTH}
      fixes :confirm, truncate: {maximum: MAX_BUTTON_TEXT_LENGTH}

      validates :deny, presence: true, length: {maximum: MAX_BUTTON_TEXT_LENGTH}
      fixes :deny, truncate: {maximum: MAX_BUTTON_TEXT_LENGTH}

      validates :style, presence: true, inclusion: {in: VALID_STYLES}, allow_nil: true
      fixes :style, null_value: {error_types: [:blank, :inclusion]}

      def as_json(*)
        {
          title: title&.as_json,
          text: text&.as_json,
          confirm: confirm&.as_json,
          deny: deny&.as_json,
          style: style
        }.compact
      end
    end
  end
end
