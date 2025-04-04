# frozen_string_literal: true

require_relative "text"

module BlockKit
  module Composition
    class PlainText < Text
      TYPE = "plain_text"

      attribute :emoji, :boolean

      def as_json(*)
        super.merge(emoji: emoji).compact
      end
    end
  end
end
