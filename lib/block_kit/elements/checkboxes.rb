# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class Checkboxes < Base
      TYPE = "checkboxes"

      attribute :options, Types::Array.of(Types::Option.instance)
      attribute :confirm, Types::ConfirmationDialog.instance
      attribute :focus_on_load, :boolean

      validates :options, presence: true, length: {maximum: 10, message: "is too long (maximum is %{count} options)"}, "block_kit/validators/associated": true
      validates :confirm, "block_kit/validators/associated": true, allow_nil: true

      def as_json(*)
        super.merge(
          options: options&.map(&:as_json),
          initial_options: options&.select(&:initial?)&.map(&:as_json),
          confirm: confirm&.as_json,
          focus_on_load: focus_on_load
        ).compact
      end
    end
  end
end
