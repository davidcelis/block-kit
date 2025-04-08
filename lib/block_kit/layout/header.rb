# frozen_string_literal: true

module BlockKit
  module Layout
    class Header < Base
      TYPE = "header"

      attribute :text, Types::PlainText.instance

      validates :text, presence: true, length: {maximum: 150}

      def as_json(*)
        super.merge(text: text&.as_json)
      end
    end
  end
end
