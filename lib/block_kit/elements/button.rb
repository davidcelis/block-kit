# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class Button < BaseButton
      MAX_URL_LENGTH = 3000
      MAX_VALUE_LENGTH = 2000

      include Concerns::Confirmable

      attribute :url, :string
      attribute :value, :string

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, length: {maximum: MAX_URL_LENGTH}, allow_nil: true
      fixes :url, truncate: {maximum: MAX_URL_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

      validates :value, presence: true, length: {maximum: MAX_VALUE_LENGTH}, allow_nil: true
      fixes :value, truncate: {maximum: MAX_VALUE_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

      def as_json(*)
        super.merge(url: url, value: value).compact
      end
    end
  end
end
