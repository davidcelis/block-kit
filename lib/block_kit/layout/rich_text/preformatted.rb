# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Preformatted < Block
      self.type = :rich_text_preformatted

      attribute :elements, Types::Array.of(*RichText::Elements.all)
      attribute :border, :integer

      validates :elements, presence: true, "block_kit/validators/associated": true
      validates :border, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

      def as_json(*)
        super.merge(
          elements: elements&.map(&:as_json),
          border: border
        ).compact
      end
    end
  end
end
