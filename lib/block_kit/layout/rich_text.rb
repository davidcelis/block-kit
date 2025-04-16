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
      fixes :elements, associated: true

      dsl_method :elements, as: :list, type: RichText::List
      dsl_method :elements, as: :preformatted, type: RichText::Preformatted
      dsl_method :elements, as: :quote, type: RichText::Quote
      dsl_method :elements, as: :section, type: RichText::Section

      alias_method :rich_text_list, :list
      alias_method :rich_text_preformatted, :preformatted
      alias_method :rich_text_quote, :quote
      alias_method :rich_text_section, :section

      def initialize(attributes = {})
        attributes = attributes.with_indifferent_access
        attributes[:elements] ||= []

        super
      end

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
