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
      fixes :elements, associated: true

      dsl_method :elements, as: :mrkdwn, type: Composition::Mrkdwn, required_fields: [:text], yields: false
      dsl_method :elements, as: :plain_text, type: Composition::PlainText, required_fields: [:text], yields: false

      def initialize(attributes = {})
        attributes = attributes.with_indifferent_access
        attributes[:elements] ||= []

        super
      end

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
