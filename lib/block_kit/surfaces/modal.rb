# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Modal < Base
      MAX_TITLE_LENGTH = 24
      MAX_BUTTON_LENGTH = 24

      self.type = :modal

      plain_text_attribute :title
      plain_text_attribute :close
      plain_text_attribute :submit
      attribute :clear_on_close, :boolean
      attribute :notify_on_close, :boolean
      attribute :submit_disabled, :boolean

      validates :title, presence: true, length: {maximum: MAX_TITLE_LENGTH}
      fixes :title, truncate: {maximum: MAX_TITLE_LENGTH}

      validates :close, presence: true, length: {maximum: MAX_BUTTON_LENGTH}, allow_nil: true
      fixes :close, truncate: {maximum: MAX_BUTTON_LENGTH}, null_value: {error_types: [:blank]}

      validates :submit, presence: true, length: {maximum: MAX_BUTTON_LENGTH}, allow_nil: true
      fixes :submit, truncate: {maximum: MAX_BUTTON_LENGTH}, null_value: {error_types: [:blank]}

      def as_json(*)
        super.merge(
          title: title&.as_json,
          close: close&.as_json,
          submit: submit&.as_json,
          clear_on_close: clear_on_close,
          notify_on_close: notify_on_close,
          submit_disabled: submit_disabled
        ).compact
      end
    end
  end
end
