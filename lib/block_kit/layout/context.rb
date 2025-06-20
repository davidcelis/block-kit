# frozen_string_literal: true

module BlockKit
  module Layout
    class Context < Base
      self.type = :context

      MAX_ELEMENTS = 10
      SUPPORTED_ELEMENTS = [
        Elements::Image,
        Composition::Mrkdwn,
        Composition::PlainText
      ].freeze

      attribute :elements, Types::Array.of(Types::Blocks.new(*SUPPORTED_ELEMENTS)), default: []
      validates :elements, presence: true, length: {maximum: MAX_ELEMENTS, message: "is too long (maximum is %{count} elements)"}, "block_kit/validators/associated": true
      fixes :elements, truncate: {maximum: MAX_ELEMENTS, dangerous: true}, associated: true

      dsl_method :elements, as: :mrkdwn, type: Composition::Mrkdwn, required_fields: [:text], yields: false
      dsl_method :elements, as: :plain_text, type: Composition::PlainText, required_fields: [:text], yields: false

      def image(alt_text:, image_url: nil, slack_file: nil)
        if (image_url.nil? && slack_file.nil?) || (image_url && slack_file)
          raise ArgumentError, "Must provide either image_url or slack_file, but not both."
        end

        append(Elements::Image.new(alt_text: alt_text, image_url: image_url, slack_file: slack_file))
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
