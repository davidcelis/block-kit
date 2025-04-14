# frozen_string_literal: true

module BlockKit
  module Layout
    class Input < Base
      self.type = :input

      SUPPORTED_ELEMENTS = [
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
        Elements::DatetimePicker,
        Elements::EmailTextInput,
        Elements::ExternalSelect,
        Elements::FileInput,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::NumberInput,
        Elements::PlainTextInput,
        Elements::RadioButtons,
        Elements::RichTextInput,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::UsersSelect,
        Elements::URLTextInput
      ].freeze

      plain_text_attribute :label
      attribute :element, Types::Blocks.new(*SUPPORTED_ELEMENTS)
      attribute :dispatch_action, :boolean
      plain_text_attribute :hint
      attribute :optional, :boolean

      include Concerns::PlainTextEmojiAssignment.new(:label, :hint)

      validates :label, presence: true, length: {maximum: 2000}
      validates :element, presence: true, "block_kit/validators/associated": true
      validates :dispatch_action, inclusion: {in: [nil, false], message: "can't be enabled for FileInputs"}, if: ->(input) { input.element.is_a?(Elements::FileInput) }
      validates :hint, length: {maximum: 2000}, allow_nil: true

      dsl_method :element, as: :channels_select, type: Elements::ChannelsSelect
      dsl_method :element, as: :checkboxes, type: Elements::Checkboxes
      dsl_method :element, as: :conversations_select, type: Elements::ConversationsSelect
      dsl_method :element, as: :datepicker, type: Elements::DatePicker
      dsl_method :element, as: :datetimepicker, type: Elements::DatetimePicker
      dsl_method :element, as: :email_text_input, type: Elements::EmailTextInput
      dsl_method :element, as: :external_select, type: Elements::ExternalSelect
      dsl_method :element, as: :file_input, type: Elements::FileInput
      dsl_method :element, as: :multi_channels_select, type: Elements::MultiChannelsSelect
      dsl_method :element, as: :multi_conversations_select, type: Elements::MultiConversationsSelect
      dsl_method :element, as: :multi_external_select, type: Elements::MultiExternalSelect
      dsl_method :element, as: :multi_static_select, type: Elements::MultiStaticSelect, mutually_exclusive_fields: [:options, :option_groups]
      dsl_method :element, as: :multi_users_select, type: Elements::MultiUsersSelect
      dsl_method :element, as: :number_input, type: Elements::NumberInput
      dsl_method :element, as: :plain_text_input, type: Elements::PlainTextInput
      dsl_method :element, as: :radio_buttons, type: Elements::RadioButtons
      dsl_method :element, as: :rich_text_input, type: Elements::RichTextInput
      dsl_method :element, as: :static_select, type: Elements::StaticSelect, mutually_exclusive_fields: [:options, :option_groups]
      dsl_method :element, as: :timepicker, type: Elements::TimePicker
      dsl_method :element, as: :users_select, type: Elements::UsersSelect
      dsl_method :element, as: :url_text_input, type: Elements::URLTextInput

      alias_method :channel_select, :channels_select
      alias_method :conversation_select, :conversations_select
      alias_method :date_picker, :datepicker
      alias_method :datetime_picker, :datetimepicker
      alias_method :email_input, :email_text_input
      alias_method :multi_channel_select, :multi_channels_select
      alias_method :multi_conversation_select, :multi_conversations_select
      alias_method :multi_user_select, :multi_users_select
      alias_method :text_input, :plain_text_input
      alias_method :time_picker, :timepicker
      alias_method :user_select, :users_select

      def optional?
        !!optional
      end

      def required?
        !optional?
      end

      def dispatch_action?
        !!dispatch_action
      end

      def as_json(*)
        super.merge(
          label: label&.as_json,
          element: element&.as_json,
          dispatch_action: dispatch_action,
          hint: hint&.as_json,
          optional: optional
        ).compact
      end
    end
  end
end
