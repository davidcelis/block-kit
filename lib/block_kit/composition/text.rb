# frozen_string_literal: true

module BlockKit
  module Composition
    class Text < Block
      attribute :text, :string

      delegate :blank?, :truncate, to: :text

      def length
        text&.length || 0
      end

      def as_json(*)
        super.merge(text: text)
      end
    end
  end
end
