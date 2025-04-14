# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasPlaceholder
      extend ActiveSupport::Concern

      included do
        plain_text_attribute :placeholder
        validates :placeholder, presence: true, length: {maximum: 150}, allow_nil: true
      end

      def as_json(*)
        super.merge(placeholder: placeholder&.as_json).compact
      end
    end
  end
end
