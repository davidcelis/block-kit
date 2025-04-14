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

      attribute :label, Types::Block.of_type(Composition::PlainText)
      attribute :element, Types::Blocks.new(*SUPPORTED_ELEMENTS)
      attribute :dispatch_action, :boolean
      attribute :hint, Types::Block.of_type(Composition::PlainText)
      attribute :optional, :boolean

      include Concerns::PlainTextEmojiAssignment.new(:label, :hint)

      validates :label, presence: true, length: {maximum: 2000}
      validates :element, presence: true, "block_kit/validators/associated": true
      validates :dispatch_action, inclusion: {in: [nil, false], message: "can't be enabled for FileInputs"}, if: ->(input) { input.element.is_a?(Elements::FileInput) }
      validates :hint, length: {maximum: 2000}, allow_nil: true

      def optional?
        !!optional
      end

      def required?
        !optional?
      end

      def dispatch_action?
        !!dispatch_action
      end

      def channels_select(placeholder: nil, initial_channel: nil, response_url_enabled: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::ChannelsSelect.new(
          placeholder: placeholder,
          initial_channel: initial_channel,
          response_url_enabled: response_url_enabled,
          confirm: confirm,
          focus_on_load: focus_on_load,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :channel_select, :channels_select

      def checkboxes(options: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        self.element = Elements::Checkboxes.new(options: options, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(element) if block_given?

        self
      end

      def conversations_select(placeholder: nil, initial_conversation: nil, default_to_current_conversation: nil, response_url_enabled: nil, focus_on_load: nil, confirm: nil, filter: nil, emoji: nil, action_id: nil)
        self.element = Elements::ConversationsSelect.new(
          placeholder: placeholder,
          initial_conversation: initial_conversation,
          default_to_current_conversation: default_to_current_conversation,
          response_url_enabled: response_url_enabled,
          focus_on_load: focus_on_load,
          confirm: confirm,
          filter: filter,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :conversation_select, :conversations_select

      def datepicker(placeholder: nil, initial_date: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::DatePicker.new(
          placeholder: placeholder,
          initial_date: initial_date,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :date_picker, :datepicker

      def datetimepicker(initial_date_time: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        self.element = Elements::DatetimePicker.new(initial_date_time: initial_date_time, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(element) if block_given?

        self
      end
      alias_method :datetime_picker, :datetimepicker

      def email_text_input(placeholder: nil, initial_value: nil, focus_on_load: nil, dispatch_action_config: nil, emoji: nil, action_id: nil)
        self.element = Elements::EmailTextInput.new(
          placeholder: placeholder,
          initial_value: initial_value,
          focus_on_load: focus_on_load,
          dispatch_action_config: dispatch_action_config,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :email_input, :email_text_input

      def external_select(placeholder: nil, initial_option: nil, min_query_length: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::ExternalSelect.new(
          placeholder: placeholder,
          initial_option: initial_option,
          min_query_length: min_query_length,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end

      def file_input(filetypes: nil, max_files: nil, action_id: nil)
        self.element = Elements::FileInput.new(filetypes: filetypes, max_files: max_files, action_id: action_id)

        yield(element) if block_given?

        self
      end

      def multi_channels_select(placeholder: nil, initial_channels: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::MultiChannelsSelect.new(
          placeholder: placeholder,
          initial_channels: initial_channels,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :multi_channel_select, :multi_channels_select

      def multi_conversations_select(placeholder: nil, initial_conversations: nil, max_selected_items: nil, default_to_current_conversation: nil, focus_on_load: nil, confirm: nil, filter: nil, emoji: nil, action_id: nil)
        self.element = Elements::MultiConversationsSelect.new(
          placeholder: placeholder,
          initial_conversations: initial_conversations,
          max_selected_items: max_selected_items,
          default_to_current_conversation: default_to_current_conversation,
          focus_on_load: focus_on_load,
          confirm: confirm,
          filter: filter,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :multi_conversation_select, :multi_conversations_select

      def multi_external_select(placeholder: nil, initial_options: nil, min_query_length: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::MultiExternalSelect.new(
          placeholder: placeholder,
          initial_options: initial_options,
          min_query_length: min_query_length,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end

      def multi_static_select(placeholder: nil, options: nil, option_groups: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        if options && option_groups
          raise ArgumentError, "Can't provide both options and option_groups"
        end

        self.element = Elements::MultiStaticSelect.new(
          placeholder: placeholder,
          options: options,
          option_groups: option_groups,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end

      def multi_users_select(placeholder: nil, initial_users: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::MultiUsersSelect.new(
          placeholder: placeholder,
          initial_users: initial_users,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :multi_user_select, :multi_users_select

      def number_input(placeholder: nil, is_decimal_allowed: nil, initial_value: nil, min_value: nil, max_value: nil, focus_on_load: nil, dispatch_action_config: nil, emoji: nil, action_id: nil)
        self.element = Elements::NumberInput.new(
          placeholder: placeholder,
          is_decimal_allowed: is_decimal_allowed,
          initial_value: initial_value,
          min_value: min_value,
          max_value: max_value,
          focus_on_load: focus_on_load,
          dispatch_action_config: dispatch_action_config,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end

      def plain_text_input(placeholder: nil, initial_value: nil, min_length: nil, max_length: nil, multiline: nil, focus_on_load: nil, dispatch_action_config: nil, emoji: nil, action_id: nil)
        self.element = Elements::PlainTextInput.new(
          placeholder: placeholder,
          initial_value: initial_value,
          min_length: min_length,
          max_length: max_length,
          multiline: multiline,
          focus_on_load: focus_on_load,
          dispatch_action_config: dispatch_action_config,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :text_input, :plain_text_input

      def radio_buttons(options: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        self.element = Elements::RadioButtons.new(options: options, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(element) if block_given?

        self
      end

      def rich_text_input(placeholder: nil, initial_value: nil, focus_on_load: nil, dispatch_action_config: nil, action_id: nil)
        self.element = Elements::RichTextInput.new(
          placeholder: placeholder,
          initial_value: initial_value,
          focus_on_load: focus_on_load,
          dispatch_action_config: dispatch_action_config,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end

      def static_select(placeholder: nil, options: nil, option_groups: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        if options && option_groups
          raise ArgumentError, "Can't provide both options and option_groups"
        end

        self.element = Elements::StaticSelect.new(
          placeholder: placeholder,
          options: options,
          option_groups: option_groups,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end

      def timepicker(placeholder: nil, initial_time: nil, timezone: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::TimePicker.new(
          placeholder: placeholder,
          initial_time: initial_time,
          timezone: timezone,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :time_picker, :timepicker

      def users_select(placeholder: nil, initial_user: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.element = Elements::UsersSelect.new(
          placeholder: placeholder,
          initial_user: initial_user,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
      end
      alias_method :user_select, :users_select

      def url_text_input(placeholder: nil, initial_value: nil, focus_on_load: nil, dispatch_action_config: nil, emoji: nil, action_id: nil)
        self.element = Elements::URLTextInput.new(
          placeholder: placeholder,
          initial_value: initial_value,
          focus_on_load: focus_on_load,
          dispatch_action_config: dispatch_action_config,
          emoji: emoji,
          action_id: action_id
        )

        yield(element) if block_given?

        self
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
