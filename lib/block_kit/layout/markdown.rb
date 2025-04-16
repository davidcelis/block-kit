# frozen_string_literal: true

module BlockKit
  module Layout
    class Markdown < Base
      MAX_LENGTH = 12_000

      self.type = :markdown

      attribute :text, :string
      validates :text, presence: true, length: {maximum: MAX_LENGTH}
      fixes :text, truncate: {maximum: MAX_LENGTH}

      def as_json(*)
        super.merge(text: text).compact
      end
    end
  end
end
