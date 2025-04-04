# frozen_string_literal: true

require_relative "../block"
require_relative "../types/text_block"

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
