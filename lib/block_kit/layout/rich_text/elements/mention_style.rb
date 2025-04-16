# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::MentionStyle < BlockKit::Base
      self.type = :rich_text_element_mention_style

      attribute :bold, :boolean
      attribute :italic, :boolean
      attribute :strike, :boolean
      attribute :highlight, :boolean
      attribute :client_highlight, :boolean
      attribute :unlink, :boolean

      def as_json(*)
        {
          bold: bold,
          italic: italic,
          strike: strike,
          highlight: highlight,
          client_highlight: client_highlight,
          unlink: unlink
        }.compact
      end
    end
  end
end
