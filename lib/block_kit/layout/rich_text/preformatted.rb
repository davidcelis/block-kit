# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Preformatted < Block
      self.type = :rich_text_preformatted

      include Concerns::HasRichTextElements

      attribute :border, :integer
      validates :border, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

      def as_json(*)
        super.merge(border: border).compact
      end
    end
  end
end
