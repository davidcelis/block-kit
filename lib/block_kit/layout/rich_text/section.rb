# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Section < Block
      self.type = :rich_text_section

      attribute :elements, Types::Array.of(Types::Blocks.new(*RichText::Elements.all))

      validates :elements, presence: true, "block_kit/validators/associated": true

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
