# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class RichTextInput < Base
      self.type = :rich_text_input

      include Concerns::Dispatchable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder
      include Concerns::PlainTextEmojiAssignment.new(:placeholder)

      attribute :initial_value, Types::Block.of_type(Layout::RichText)
      validates :initial_value, presence: true, "block_kit/validators/associated": true, allow_nil: true

      def as_json(*)
        super.merge(initial_value: initial_value&.as_json).compact
      end
    end
  end
end
