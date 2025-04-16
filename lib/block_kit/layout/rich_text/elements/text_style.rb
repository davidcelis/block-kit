# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::TextStyle < BlockKit::Base
      self.type = :rich_text_element_text_style

      attribute :bold, :boolean
      attribute :italic, :boolean
      attribute :strike, :boolean
      attribute :code, :boolean

      def as_json(*)
        {
          bold: bold,
          italic: italic,
          strike: strike,
          code: code
        }.compact
      end
    end
  end
end
