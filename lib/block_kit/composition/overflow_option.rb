# frozen_string_literal: true

require "uri"

module BlockKit
  module Composition
    class OverflowOption < Option
      attribute :url, :string

      validates :url, presence: true, format: URI::RFC2396_PARSER.make_regexp, length: {maximum: 3000}, allow_nil: true

      def as_json(*)
        super.merge(url: url).compact
      end
    end
  end
end
