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
