# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class Button < Base
      TYPE = "button"

      attribute :text, Types::PlainText.instance
      attribute :url, :string
      attribute :value, :string
      attribute :style, :string
      attribute :confirm, Types::ConfirmationDialog.instance
      attribute :accessibility_label, :string

      self.required_attributes = [:text]

      validates :text, presence: true, length: {maximum: 75}
      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, length: {maximum: 3000}, allow_nil: true
      validates :value, presence: true, length: {maximum: 2000}, allow_nil: true
      validates :style, presence: true, inclusion: {in: %w[primary danger]}, allow_nil: true
      validates :confirm, "block_kit/validators/associated": true, allow_nil: true
      validates :accessibility_label, presence: true, length: {maximum: 75}, allow_nil: true

      def as_json(*)
        super.merge(
          text: text&.as_json,
          url: url,
          value: value,
          style: style,
          confirm: confirm&.as_json,
          accessibility_label: accessibility_label
        ).compact
      end
    end
  end
end
