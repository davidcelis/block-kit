# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasPlaceholder
      MAX_TEXT_LENGTH = 150

      extend ActiveSupport::Concern

      included do
        plain_text_attribute :placeholder
        validates :placeholder, presence: true, length: {maximum: MAX_TEXT_LENGTH}, allow_nil: true
        fixes :placeholder, truncate: {maximum: MAX_TEXT_LENGTH}
      end

      def as_json(*)
        super.merge(placeholder: placeholder&.as_json).compact
      end
    end
  end
end
