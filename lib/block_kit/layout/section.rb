# frozen_string_literal: true

module BlockKit
  module Layout
    class Section < Base
      self.type = :section

      SUPPORTED_ELEMENTS = [
        Elements::Button,
        Elements::Checkboxes,
        Elements::DatePicker,
        Elements::Image,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::Overflow,
        Elements::RadioButtons,
        Elements::ChannelsSelect,
        Elements::ConversationsSelect,
        Elements::ExternalSelect,
        Elements::StaticSelect,
        Elements::UsersSelect,
        Elements::TimePicker,
        Elements::WorkflowButton
      ].freeze

      attribute :text, Types::Text.instance
      attribute :fields, Types::Array.of(Types::Text.instance)
      attribute :accessory, Types::Blocks.new(*SUPPORTED_ELEMENTS)
      attribute :expand, :boolean

      validates :text, length: {maximum: 3000}, presence: {allow_nil: true}
      validates :fields, length: {maximum: 10, message: "is too long (maximum is %{count} fields)"}, presence: {allow_nil: true}
      validates :accessory, "block_kit/validators/associated": true
      validate :has_text_or_fields
      validate :fields_are_valid

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
