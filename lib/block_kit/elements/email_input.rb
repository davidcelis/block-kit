# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class EmailInput < Base
      self.type = :email_text_input

      include Concerns::FocusableOnLoad

      attribute :initial_value, :string
      attribute :dispatch_action_config, Types::Block.of_type(Composition::DispatchActionConfig)
      attribute :placeholder, Types::PlainText.instance

      alias_attribute :dispatch_action_configuration, :dispatch_action_config

      validates :initial_value, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_nil: true
      validates :dispatch_action_config, presence: true, "block_kit/validators/associated": true, allow_nil: true
      validates :placeholder, presence: true, length: {maximum: 150}, allow_nil: true

      def as_json(*)
        super.merge(
          initial_value: initial_value,
          dispatch_action_config: dispatch_action_config&.as_json,
          placeholder: placeholder&.as_json
        ).compact
      end
    end
  end
end
