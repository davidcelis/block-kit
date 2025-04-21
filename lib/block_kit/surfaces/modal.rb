# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Modal < Base
      self.type = :modal

      MAX_TITLE_LENGTH = 24
      MAX_BUTTON_LENGTH = 24
      SUPPORTED_ELEMENTS = [
        Elements::Button,
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
        Elements::DatetimePicker,
        Elements::EmailTextInput,
        Elements::ExternalSelect,
        Elements::FileInput,
        Elements::Image,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::NumberInput,
        Elements::Overflow,
        Elements::PlainTextInput,
        Elements::RadioButtons,
        Elements::RichTextInput,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::URLTextInput,
        Elements::UsersSelect
      ].freeze

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
      validate :submit_present_if_contains_input
      fixes :submit, truncate: {maximum: MAX_BUTTON_LENGTH}, null_value: {error_types: [:blank]}
      fix :add_default_submit_button

      def initialize(attributes = {})
        attributes = attributes.with_indifferent_access
        attributes[:blocks] ||= []

        super
      end

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

      private

      def submit_present_if_contains_input
        errors.add(:submit, "can't be blank when blocks contain input elements") if contains_input? && submit.blank?
      end

      def add_default_submit_button
        self.submit = "Submit" if contains_input? && submit.blank?
      end

      def contains_input?
        blocks.any? { |block| block.is_a?(Layout::Input) }
      end
    end
  end
end
