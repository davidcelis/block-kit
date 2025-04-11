# frozen_string_literal: true

module BlockKit
  module Layout
    class Actions < Base
      self.type = :actions

      SUPPORTED_ELEMENTS = [
        Elements::Button,
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
        Elements::DatetimePicker,
        Elements::ExternalSelect,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::Overflow,
        Elements::RadioButtons,
        Elements::RichTextInput,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::UsersSelect,
        Elements::WorkflowButton
      ]

      attribute :elements, Types::Array.of(Types::Blocks.new(*SUPPORTED_ELEMENTS))

      validates :elements, presence: true, length: {maximum: 25, message: "is too long (maximum is %{count} elements)"}, "block_kit/validators/associated": true

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
