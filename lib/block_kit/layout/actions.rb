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

      def button(text: nil, value: nil, url: nil, style: nil, accessibility_label: nil, emoji: nil, action_id: nil)
        block = Elements::Button.new(
          text: text,
          value: value,
          url: url,
          style: style,
          accessibility_label: accessibility_label,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

      def channels_select(placeholder: nil, initial_channel: nil, response_url_enabled: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::ChannelsSelect.new(
          placeholder: placeholder,
          initial_channel: initial_channel,
          response_url_enabled: response_url_enabled,
          confirm: confirm,
          focus_on_load: focus_on_load,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end
      alias_method :channel_select, :channels_select

      def checkboxes(options: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        block = Elements::Checkboxes.new(options: options, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(block) if block_given?

        append(block)
      end

      def conversations_select(placeholder: nil, initial_conversation: nil, default_to_current_conversation: nil, response_url_enabled: nil, focus_on_load: nil, confirm: nil, filter: nil, emoji: nil, action_id: nil)
        block = Elements::ConversationsSelect.new(
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

        yield(block) if block_given?

        append(block)
      end
      alias_method :conversation_select, :conversations_select

      def datepicker(placeholder: nil, initial_date: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::DatePicker.new(
          placeholder: placeholder,
          initial_date: initial_date,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end
      alias_method :date_picker, :datepicker

      def datetimepicker(initial_date_time: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        block = Elements::DatetimePicker.new(initial_date_time: initial_date_time, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(block) if block_given?

        append(block)
      end
      alias_method :datetime_picker, :datetimepicker

      def external_select(placeholder: nil, initial_option: nil, min_query_length: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::ExternalSelect.new(
          placeholder: placeholder,
          initial_option: initial_option,
          min_query_length: min_query_length,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

      def multi_channels_select(placeholder: nil, initial_channels: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::MultiChannelsSelect.new(
          placeholder: placeholder,
          initial_channels: initial_channels,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end
      alias_method :multi_channel_select, :multi_channels_select

      def multi_conversations_select(placeholder: nil, initial_conversations: nil, max_selected_items: nil, default_to_current_conversation: nil, focus_on_load: nil, confirm: nil, filter: nil, emoji: nil, action_id: nil)
        block = Elements::MultiConversationsSelect.new(
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

        yield(block) if block_given?

        append(block)
      end
      alias_method :multi_conversation_select, :multi_conversations_select

      def multi_external_select(placeholder: nil, initial_options: nil, min_query_length: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::MultiExternalSelect.new(
          placeholder: placeholder,
          initial_options: initial_options,
          min_query_length: min_query_length,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

      def multi_static_select(placeholder: nil, options: nil, option_groups: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        if options && option_groups
          raise ArgumentError, "Can't provide both options and option_groups"
        end

        block = Elements::MultiStaticSelect.new(
          placeholder: placeholder,
          options: options,
          option_groups: option_groups,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

      def multi_users_select(placeholder: nil, initial_users: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::MultiUsersSelect.new(
          placeholder: placeholder,
          initial_users: initial_users,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end
      alias_method :multi_user_select, :multi_users_select

      def overflow(options: nil, confirm: nil, action_id: nil)
        block = Elements::Overflow.new(options: options, confirm: confirm, action_id: action_id)

        yield(block) if block_given?

        append(block)
      end
      alias_method :overflow_menu, :overflow

      def radio_buttons(options: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        block = Elements::RadioButtons.new(options: options, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(block) if block_given?

        append(block)
      end

      def rich_text_input(placeholder: nil, initial_value: nil, focus_on_load: nil, dispatch_action_config: nil, action_id: nil)
        block = Elements::RichTextInput.new(
          placeholder: placeholder,
          initial_value: initial_value,
          focus_on_load: focus_on_load,
          dispatch_action_config: dispatch_action_config,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

      def static_select(placeholder: nil, options: nil, option_groups: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        if options && option_groups
          raise ArgumentError, "Can't provide both options and option_groups"
        end

        block = Elements::StaticSelect.new(
          placeholder: placeholder,
          options: options,
          option_groups: option_groups,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

      def timepicker(placeholder: nil, initial_time: nil, timezone: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::TimePicker.new(
          placeholder: placeholder,
          initial_time: initial_time,
          timezone: timezone,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end
      alias_method :time_picker, :timepicker

      def users_select(placeholder: nil, initial_user: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        block = Elements::UsersSelect.new(
          placeholder: placeholder,
          initial_user: initial_user,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end
      alias_method :user_select, :users_select

      def workflow_button(text: nil, workflow: nil, style: nil, accessibility_label: nil, emoji: nil, action_id: nil)
        block = Elements::WorkflowButton.new(
          text: text,
          workflow: workflow,
          style: style,
          accessibility_label: accessibility_label,
          emoji: emoji,
          action_id: action_id
        )

        yield(block) if block_given?

        append(block)
      end

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
