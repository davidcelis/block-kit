# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText < Base
      self.type = :rich_text

      autoload :Elements, "block_kit/layout/rich_text/elements"
      autoload :List, "block_kit/layout/rich_text/list"
      autoload :Preformatted, "block_kit/layout/rich_text/preformatted"
      autoload :Quote, "block_kit/layout/rich_text/quote"
      autoload :Section, "block_kit/layout/rich_text/section"

      SUPPORTED_ELEMENTS = [
        RichText::List,
        RichText::Preformatted,
        RichText::Quote,
        RichText::Section
      ].freeze

      attribute :elements, Types::Array.of(Types::Blocks.new(*SUPPORTED_ELEMENTS))

      validates :elements, presence: true, "block_kit/validators/associated": true

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
