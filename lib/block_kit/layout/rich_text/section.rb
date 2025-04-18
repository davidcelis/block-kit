# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Section < BlockKit::Base
      self.type = :rich_text_section

      include Concerns::HasRichTextElements
    end
  end
end
