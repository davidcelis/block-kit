# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      self.type = :header

      attribute :text, Types::Block.of_type(Composition::PlainText)

      include Concerns::PlainTextEmojiAssignment.new(:text)

      validates :text, presence: true, length: {maximum: 150}

      def as_json(*)
        super.merge(text: text&.as_json)
      end
    end
  end
end
