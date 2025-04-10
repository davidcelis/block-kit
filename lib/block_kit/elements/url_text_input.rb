# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class URLTextInput < Base
      self.type = :url_text_input

      include Concerns::Dispatchable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      attribute :initial_value, :string

      validates :initial_value, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URI", allow_blank: true}, allow_nil: true

      def as_json(*)
        super.merge(initial_value: initial_value).compact
      end
    end
  end
end
