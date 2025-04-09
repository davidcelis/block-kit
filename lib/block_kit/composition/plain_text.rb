# frozen_string_literal: true

module BlockKit
  module Composition
    class PlainText < Text
      self.type = :plain_text

      attribute :emoji, :boolean

      def as_json(*)
        super.merge(emoji: emoji).compact
      end
    end
  end
end
