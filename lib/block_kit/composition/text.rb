# frozen_string_literal: true

module BlockKit
  module Composition
    class Text < Block
      attribute :text, :string

      delegate :length, :blank?, to: :text

      def as_json(*)
        super.merge(text: text)
      end
    end
  end
end
