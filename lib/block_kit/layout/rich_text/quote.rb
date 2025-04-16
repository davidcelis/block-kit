# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Quote < Block
      self.type = :rich_text_quote

      include Concerns::HasRichTextElements

      attribute :border, :integer
      validates :border, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
      fixes :border, null_value: {error_types: [:greater_than_or_equal_to]}

      def as_json(*)
        super.merge(border: border).compact
      end
    end
  end
end
