# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      self.type = :header

      MAX_LENGTH = 150

      plain_text_attribute :text

      include Concerns::PlainTextEmojiAssignment.new(:text)

      validates :text, presence: true, length: {maximum: MAX_LENGTH}
      fixes :text, truncate: {maximum: MAX_LENGTH}

      def as_json(*)
        super.merge(text: text&.as_json)
      end
    end
  end
end
