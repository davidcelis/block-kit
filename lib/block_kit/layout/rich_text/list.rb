# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::List < Block
      self.type = :rich_text_list

      VALID_STYLES = [
        BULLET = "bullet",
        ORDERED = "ordered"
      ].freeze

      attribute :style, :string
      attribute :elements, Types::Array.of(RichText::Section)
      attribute :indent, :integer
      attribute :offset, :integer
      attribute :border, :integer

      validates :style, presence: true, inclusion: {in: VALID_STYLES}
      validates :elements, presence: true, "block_kit/validators/associated": true
      validates :indent, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
      validates :offset, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
      validates :border, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

      fixes :elements, associated: true

      dsl_method :elements, as: :section, type: RichText::Section
      alias_method :rich_text_section, :section

      def as_json(*)
        super.merge(
          style: style,
          elements: elements&.map(&:as_json),
          indent: indent,
          offset: offset,
          border: border
        ).compact
      end
    end
  end
end
