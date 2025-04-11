# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class RichText::Elements::Date < Block
      self.type = :date

      attribute :timestamp, :datetime
      attribute :format, :string
      attribute :url, :string
      attribute :fallback, :string

      validates :timestamp, presence: true
      validates :format, presence: true
      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, allow_nil: true
      validates :fallback, presence: true, allow_nil: true

      def as_json(*)
        super.merge(
          timestamp: timestamp.to_i,
          format: format,
          url: url,
          fallback: fallback
        ).compact
      end
    end
  end
end
