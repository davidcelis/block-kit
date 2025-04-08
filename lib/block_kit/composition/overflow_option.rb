# frozen_string_literal: true

require "uri"

module BlockKit
  module Composition
    class OverflowOption < Option
      attribute :url, :string

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, length: {maximum: 3000}, allow_nil: true

      def as_json(*)
        super.merge(url: url).compact
      end
    end
  end
end
