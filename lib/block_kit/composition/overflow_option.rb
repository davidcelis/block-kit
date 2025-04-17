# frozen_string_literal: true

require "uri"

module BlockKit
  module Composition
    class OverflowOption < Option
      self.type = :overflow_option

      MAX_URL_LENGTH = 3000

      attribute :url, :string
      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, length: {maximum: MAX_URL_LENGTH}, allow_nil: true
      fixes :url, truncate: {maximum: MAX_URL_LENGTH, dangerous: true, omission: ""}, null_value: [:blank]

      def as_json(*)
        super.merge(url: url).compact
      end
    end
  end
end
