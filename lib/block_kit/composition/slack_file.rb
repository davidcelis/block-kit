# frozen_string_literal: true

require "uri"

module BlockKit
  module Composition
    class SlackFile < Block
      attribute :id, :string
      attribute :url, :string

      validates :id, presence: true, format: {with: /\AF[A-Z0-9]{8,}\z/, allow_blank: true}, allow_nil: true
      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true}, allow_nil: true

      validate :id_or_url_present

      def as_json(*)
        {id: id, url: url}.compact
      end

      private

      def id_or_url_present
        if (id.blank? && url.blank?) || (id.present? && url.present?)
          errors.add(:base, "must have either an id or url, but not both")
        end
      end
    end
  end
end
