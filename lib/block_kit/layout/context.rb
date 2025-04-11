# frozen_string_literal: true

module BlockKit
  module Layout
    class Context < Base
      self.type = :context

      SUPPORTED_ELEMENTS = [
        Elements::Image,
        Composition::Mrkdwn,
        Composition::PlainText
      ].freeze

      attribute :elements, Types::Array.of(Types::Blocks.new(*SUPPORTED_ELEMENTS))

      validates :elements, presence: true, length: {maximum: 10, message: "is too long (maximum is %{count} elements)"}, "block_kit/validators/associated": true

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
