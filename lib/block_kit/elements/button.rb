# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class Button < BaseButton
      include Concerns::Confirmable

      attribute :url, :string
      attribute :value, :string

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, length: {maximum: 3000}, allow_nil: true
      validates :value, presence: true, length: {maximum: 2000}, allow_nil: true

      def as_json(*)
        super.merge(url: url, value: value).compact
      end
    end
  end
end
