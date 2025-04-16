# frozen_string_literal: true

module BlockKit
  module Layout
    class Section < Base
      MAX_TEXT_LENGTH = 3000
      MAX_FIELDS = 10
      MAX_FIELD_TEXT_LENGTH = 2000

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

      validates :text, length: {maximum: MAX_TEXT_LENGTH}, presence: {allow_nil: true}
      fixes :text, truncate: {maximum: MAX_TEXT_LENGTH}

      validates :fields, length: {maximum: MAX_FIELDS, message: "is too long (maximum is %{count} fields)"}, presence: {allow_nil: true}
      fix :truncate_long_fields
      fix :remove_blank_fields

      validates :accessory, "block_kit/validators/associated": true
      fixes :accessory, associated: true

      validate :has_text_or_fields
      validate :fields_are_valid

      def expand?
        !!expand
      end

      dsl_method :text, as: :mrkdwn, type: Composition::Mrkdwn, required_fields: [:text], yields: false
      dsl_method :text, as: :plain_text, type: Composition::PlainText, required_fields: [:text], yields: false
      dsl_method :fields, as: :mrkdwn_field, type: Composition::Mrkdwn, required_fields: [:text], yields: false
      dsl_method :fields, as: :plain_text_field, type: Composition::PlainText, required_fields: [:text], yields: false
      dsl_method :accessory, as: :button, type: Elements::Button, required_fields: [:text]
      dsl_method :accessory, as: :channels_select, type: Elements::ChannelsSelect
      dsl_method :accessory, as: :checkboxes, type: Elements::Checkboxes
      dsl_method :accessory, as: :conversations_select, type: Elements::ConversationsSelect
      dsl_method :accessory, as: :datepicker, type: Elements::DatePicker
      dsl_method :accessory, as: :external_select, type: Elements::ExternalSelect
      dsl_method :accessory, as: :multi_channels_select, type: Elements::MultiChannelsSelect
      dsl_method :accessory, as: :multi_conversations_select, type: Elements::MultiConversationsSelect
      dsl_method :accessory, as: :multi_external_select, type: Elements::MultiExternalSelect
      dsl_method :accessory, as: :multi_static_select, type: Elements::MultiStaticSelect, mutually_exclusive_fields: [:options, :option_groups]
      dsl_method :accessory, as: :multi_users_select, type: Elements::MultiUsersSelect
      dsl_method :accessory, as: :overflow, type: Elements::Overflow
      dsl_method :accessory, as: :radio_buttons, type: Elements::RadioButtons
      dsl_method :accessory, as: :static_select, type: Elements::StaticSelect, mutually_exclusive_fields: [:options, :option_groups]
      dsl_method :accessory, as: :timepicker, type: Elements::TimePicker
      dsl_method :accessory, as: :users_select, type: Elements::UsersSelect
      dsl_method :accessory, as: :workflow_button, type: Elements::WorkflowButton, required_fields: [:text]

      alias_method :channel_select, :channels_select
      alias_method :conversation_select, :conversations_select
      alias_method :date_picker, :datepicker
      alias_method :multi_channel_select, :multi_channels_select
      alias_method :multi_conversation_select, :multi_conversations_select
      alias_method :multi_user_select, :multi_users_select
      alias_method :overflow_menu, :overflow
      alias_method :time_picker, :timepicker
      alias_method :user_select, :users_select

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

      def image(alt_text:, image_url: nil, slack_file: nil)
        if (image_url.nil? && slack_file.nil?) || (image_url && slack_file)
          raise ArgumentError, "Must provide either image_url or slack_file, but not both."
        end

        self.accessory = Elements::Image.new(alt_text: alt_text, image_url: image_url, slack_file: slack_file)

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
          if field.length > MAX_FIELD_TEXT_LENGTH
            errors.add("fields[#{i}]", "is invalid: text is too long (maximum is #{MAX_FIELD_TEXT_LENGTH} characters)")
          elsif field.blank?
            errors.add("fields[#{i}]", "is invalid: text can't be blank")
          end
        end
      end

      def truncate_long_fields
        Array(fields).select { |field| field.length > MAX_FIELD_TEXT_LENGTH }.each do |field|
          field.text = field.text.truncate(MAX_FIELD_TEXT_LENGTH)
        end
      end

      def remove_blank_fields
        Array(fields).select(&:blank?).each do |field|
          fields.delete(field)
        end
      end
    end
  end
end
