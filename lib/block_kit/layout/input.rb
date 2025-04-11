# frozen_string_literal: true

module BlockKit
  module Layout
    class Input < Base
      self.type = :input

      include Concerns::Dispatchable

      SUPPORTED_ELEMENTS = [
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
        Elements::DatetimePicker,
        Elements::DecimalInput,
        Elements::EmailTextInput,
        Elements::ExternalSelect,
        Elements::FileInput,
        Elements::IntegerInput,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::PlainTextInput,
        Elements::RadioButtons,
        Elements::RichTextInput,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::UsersSelect,
        Elements::URLTextInput
      ].freeze

      attribute :label, Types::PlainText.instance
      attribute :element, Types::Blocks.new(*SUPPORTED_ELEMENTS)
      attribute :hint, Types::PlainText.instance
      attribute :optional, :boolean

      validates :label, presence: true, length: {maximum: 2000}
      validates :element, presence: true, "block_kit/validators/associated": true
      validates :hint, length: {maximum: 2000}, allow_nil: true

      def as_json(*)
        super.merge(
          label: label&.as_json,
          element: element&.as_json,
          hint: hint&.as_json,
          optional: optional
        ).compact
      end
    end
  end
end
