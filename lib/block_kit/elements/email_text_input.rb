# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class EmailTextInput < Base
      self.type = :email_text_input

      include Concerns::Dispatchable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder
      include Concerns::PlainTextEmojiAssignment.new(:placeholder)

      attribute :initial_value, :string
      validates :initial_value, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_nil: true
      fixes :initial_value, null_value: {error_types: [:blank, :invalid]}

      def as_json(*)
        super.merge(initial_value: initial_value).compact
      end
    end
  end
end
