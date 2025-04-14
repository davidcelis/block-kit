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

      def image(alt_text:, image_url: nil, slack_file: nil)
        if (image_url.nil? && slack_file.nil?) || (image_url && slack_file)
          raise ArgumentError, "Must provide either image_url or slack_file, but not both."
        end

        append(Elements::Image.new(alt_text: alt_text, image_url: image_url, slack_file: slack_file))
      end

      def mrkdwn(text:, verbatim: nil)
        append(Composition::Mrkdwn.new(text: text, verbatim: verbatim))
      end

      def plain_text(text:, emoji: nil)
        append(Composition::PlainText.new(text: text, emoji: emoji))
      end

      def append(element)
        elements << element

        self
      end

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
