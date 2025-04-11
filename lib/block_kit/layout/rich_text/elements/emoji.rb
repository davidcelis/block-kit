# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Emoji < Block
      self.type = :emoji

      attribute :name, :string
      attribute :unicode, :string

      validates :name, presence: true
      validates :unicode, presence: true, allow_nil: true

      def as_json(*)
        super.merge(
          name: name,
          unicode: unicode
        ).compact
      end
    end
  end
end
