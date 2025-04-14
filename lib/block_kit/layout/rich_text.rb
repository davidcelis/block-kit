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

      def list(style: nil, elements: nil, indent: nil, offset: nil, border: nil)
        block = RichText::List.new(style: style, elements: elements, indent: indent, offset: offset, border: border)

        yield(block) if block_given?

        append(block)
      end
      alias_method :rich_text_list, :list

      def preformatted(elements: nil, border: nil)
        block = RichText::Preformatted.new(elements: elements, border: border)

        yield(block) if block_given?

        append(block)
      end
      alias_method :rich_text_preformatted, :preformatted

      def quote(elements: nil, border: nil)
        block = RichText::Quote.new(elements: elements, border: border)

        yield(block) if block_given?

        append(block)
      end
      alias_method :rich_text_quote, :quote

      def section(elements: nil)
        block = RichText::Section.new(elements: elements)

        yield(block) if block_given?

        append(block)
      end
      alias_method :rich_text_section, :section

      def append(element)
        elements << element

        self
      end

      def as_json(*)
        super.merge(elements: elements&.map(&:as_json)).compact
      end
    end
  end
end
