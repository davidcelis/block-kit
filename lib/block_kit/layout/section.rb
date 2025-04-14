# frozen_string_literal: true

module BlockKit
  module Layout
    class Section < Base
      self.type = :section

      SUPPORTED_ELEMENTS = [
        Elements::Button,
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
        Elements::ExternalSelect,
        Elements::Image,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::Overflow,
        Elements::RadioButtons,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::UsersSelect,
        Elements::WorkflowButton
      ].freeze

      attribute :text, Types::Block.of_type(Composition::Text)
      attribute :fields, Types::Array.of(Composition::Text)
      attribute :accessory, Types::Blocks.new(*SUPPORTED_ELEMENTS)
      attribute :expand, :boolean

      validates :text, length: {maximum: 3000}, presence: {allow_nil: true}
      validates :fields, length: {maximum: 10, message: "is too long (maximum is %{count} fields)"}, presence: {allow_nil: true}
      validates :accessory, "block_kit/validators/associated": true
      validate :has_text_or_fields
      validate :fields_are_valid

      def expand?
        !!expand
      end

      def mrkdwn(text:, verbatim: nil)
        self.text = Composition::Mrkdwn.new(text: text, verbatim: verbatim)
      end

      def plain_text(text:, emoji: nil)
        self.text = Composition::PlainText.new(text: text, emoji: emoji)
      end

      def mrkdwn_field(text:, verbatim: nil)
        self.fields ||= []
        self.fields << Composition::Mrkdwn.new(text: text, verbatim: verbatim)
        self
      end

      def plain_text_field(text:, emoji: nil)
        self.fields ||= []
        self.fields << Composition::PlainText.new(text: text, emoji: emoji)
        self
      end

      def field(text:, type: :mrkdwn, verbatim: nil, emoji: nil)
        case type.to_sym
        when :mrkdwn
          mrkdwn_field(text: text, verbatim: verbatim)
        when :plain_text
          plain_text_field(text: text, emoji: emoji)
        else
          raise ArgumentError, "Invalid field type: #{type} (must be mrkdwn or plain_text)"
        end
      end

      def button(text: nil, value: nil, url: nil, style: nil, accessibility_label: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::Button.new(
          text: text,
          value: value,
          url: url,
          style: style,
          accessibility_label: accessibility_label,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end

      def channels_select(placeholder: nil, initial_channel: nil, response_url_enabled: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::ChannelsSelect.new(
          placeholder: placeholder,
          initial_channel: initial_channel,
          response_url_enabled: response_url_enabled,
          confirm: confirm,
          focus_on_load: focus_on_load,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end
      alias_method :channel_select, :channels_select

      def checkboxes(options: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        self.accessory = Elements::Checkboxes.new(options: options, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(accessory) if block_given?

        self
      end

      def conversations_select(placeholder: nil, initial_conversation: nil, default_to_current_conversation: nil, response_url_enabled: nil, focus_on_load: nil, confirm: nil, filter: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::ConversationsSelect.new(
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

        yield(accessory) if block_given?

        self
      end
      alias_method :conversation_select, :conversations_select

      def datepicker(placeholder: nil, initial_date: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::DatePicker.new(
          placeholder: placeholder,
          initial_date: initial_date,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end
      alias_method :date_picker, :datepicker

      def external_select(placeholder: nil, initial_option: nil, min_query_length: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::ExternalSelect.new(
          placeholder: placeholder,
          initial_option: initial_option,
          min_query_length: min_query_length,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end

      def image(alt_text:, image_url: nil, slack_file: nil)
        if (image_url.nil? && slack_file.nil?) || (image_url && slack_file)
          raise ArgumentError, "Must provide either image_url or slack_file, but not both."
        end

        self.accessory = Elements::Image.new(alt_text: alt_text, image_url: image_url, slack_file: slack_file)

        self
      end

      def multi_channels_select(placeholder: nil, initial_channels: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::MultiChannelsSelect.new(
          placeholder: placeholder,
          initial_channels: initial_channels,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end
      alias_method :multi_channel_select, :multi_channels_select

      def multi_conversations_select(placeholder: nil, initial_conversations: nil, max_selected_items: nil, default_to_current_conversation: nil, focus_on_load: nil, confirm: nil, filter: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::MultiConversationsSelect.new(
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

        yield(accessory) if block_given?

        self
      end
      alias_method :multi_conversation_select, :multi_conversations_select

      def multi_external_select(placeholder: nil, initial_options: nil, min_query_length: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::MultiExternalSelect.new(
          placeholder: placeholder,
          initial_options: initial_options,
          min_query_length: min_query_length,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end

      def multi_static_select(placeholder: nil, options: nil, option_groups: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        if options && option_groups
          raise ArgumentError, "Can't provide both options and option_groups"
        end

        self.accessory = Elements::MultiStaticSelect.new(
          placeholder: placeholder,
          options: options,
          option_groups: option_groups,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end

      def multi_users_select(placeholder: nil, initial_users: nil, max_selected_items: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::MultiUsersSelect.new(
          placeholder: placeholder,
          initial_users: initial_users,
          max_selected_items: max_selected_items,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end
      alias_method :multi_user_select, :multi_users_select

      def overflow(options: nil, confirm: nil, action_id: nil)
        self.accessory = Elements::Overflow.new(options: options, confirm: confirm, action_id: action_id)

        yield(accessory) if block_given?

        self
      end
      alias_method :overflow_menu, :overflow

      def radio_buttons(options: nil, focus_on_load: nil, confirm: nil, action_id: nil)
        self.accessory = Elements::RadioButtons.new(options: options, focus_on_load: focus_on_load, confirm: confirm, action_id: action_id)

        yield(accessory) if block_given?

        self
      end

      def static_select(placeholder: nil, options: nil, option_groups: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        if options && option_groups
          raise ArgumentError, "Can't provide both options and option_groups"
        end

        self.accessory = Elements::StaticSelect.new(
          placeholder: placeholder,
          options: options,
          option_groups: option_groups,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end

      def timepicker(placeholder: nil, initial_time: nil, timezone: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::TimePicker.new(
          placeholder: placeholder,
          initial_time: initial_time,
          timezone: timezone,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end
      alias_method :time_picker, :timepicker

      def users_select(placeholder: nil, initial_user: nil, focus_on_load: nil, confirm: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::UsersSelect.new(
          placeholder: placeholder,
          initial_user: initial_user,
          focus_on_load: focus_on_load,
          confirm: confirm,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end
      alias_method :user_select, :users_select

      def workflow_button(text: nil, workflow: nil, style: nil, accessibility_label: nil, emoji: nil, action_id: nil)
        self.accessory = Elements::WorkflowButton.new(
          text: text,
          workflow: workflow,
          style: style,
          accessibility_label: accessibility_label,
          emoji: emoji,
          action_id: action_id
        )

        yield(accessory) if block_given?

        self
      end

      def as_json(*)
        super.merge(
          text: text&.as_json,
          fields: fields&.map(&:as_json),
          accessory: accessory&.as_json,
          expand: expand
        ).compact
      end

      private

      # Pure ActiveModel validations get a little too complicated with this combo, as
      # we need to not only make sure at least one of these two is present, but that
      # neither is _blank_. It's easier to just do this in a custom validation and
      # keep the individual validations focused on presence while allowing nil.
      def has_text_or_fields
        if text.blank? && fields.blank?
          errors.add(:base, "must have either text or fields")
        end
      end

      def fields_are_valid
        fields&.each_with_index do |field, i|
          if field.length > 2000
            errors.add("fields[#{i}]", "is invalid: text is too long (maximum is 2000 characters)")
          elsif field.blank?
            errors.add("fields[#{i}]", "is invalid: text can't be blank")
          end
        end
      end
    end
  end
end
