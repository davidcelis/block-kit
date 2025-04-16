# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class RichText::Elements::Link < BlockKit::Base
      self.type = :link

      attribute :url, :string
      attribute :text, :string
      attribute :unsafe, :boolean
      attribute :style, Types::Generic.of_type(RichText::Elements::TextStyle)

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}
      validates :text, presence: true

      def as_json(*)
        super.merge(
          url: url,
          text: text,
          unsafe: unsafe,
          style: style&.as_json
        ).compact
      end
    end
  end
end
