# frozen_string_literal: true

module BlockKit
  module Layout
    class Markdown < Base
      self.type = :markdown

      attribute :text, :string
      validates :text, presence: true, length: {maximum: 12_000}

      def as_json(*)
        super.merge(text: text).compact
      end
    end
  end
end
