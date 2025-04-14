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

      dsl_method :elements, as: :button, type: Elements::Button, required_fields: [:text]
      dsl_method :elements, as: :channels_select, type: Elements::ChannelsSelect
      dsl_method :elements, as: :checkboxes, type: Elements::Checkboxes
      dsl_method :elements, as: :conversations_select, type: Elements::ConversationsSelect
      dsl_method :elements, as: :datepicker, type: Elements::DatePicker
      dsl_method :elements, as: :datetimepicker, type: Elements::DatetimePicker
      dsl_method :elements, as: :external_select, type: Elements::ExternalSelect
      dsl_method :elements, as: :multi_channels_select, type: Elements::MultiChannelsSelect
      dsl_method :elements, as: :multi_conversations_select, type: Elements::MultiConversationsSelect
      dsl_method :elements, as: :multi_external_select, type: Elements::MultiExternalSelect
      dsl_method :elements, as: :multi_static_select, type: Elements::MultiStaticSelect, mutually_exclusive_fields: [:options, :option_groups]
      dsl_method :elements, as: :multi_users_select, type: Elements::MultiUsersSelect
      dsl_method :elements, as: :overflow, type: Elements::Overflow
      dsl_method :elements, as: :radio_buttons, type: Elements::RadioButtons
      dsl_method :elements, as: :rich_text_input, type: Elements::RichTextInput
      dsl_method :elements, as: :static_select, type: Elements::StaticSelect, mutually_exclusive_fields: [:options, :option_groups]
      dsl_method :elements, as: :timepicker, type: Elements::TimePicker
      dsl_method :elements, as: :users_select, type: Elements::UsersSelect
      dsl_method :elements, as: :workflow_button, type: Elements::WorkflowButton, required_fields: [:text]

      alias_method :channel_select, :channels_select
      alias_method :conversation_select, :conversations_select
      alias_method :date_picker, :datepicker
      alias_method :datetime_picker, :datetimepicker
      alias_method :multi_channel_select, :multi_channels_select
      alias_method :multi_conversation_select, :multi_conversations_select
      alias_method :multi_user_select, :multi_users_select
      alias_method :overflow_menu, :overflow
      alias_method :time_picker, :timepicker
      alias_method :user_select, :users_select

      def append(element)
        elements << element

        self
      end

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
