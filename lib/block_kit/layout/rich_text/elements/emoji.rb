# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Emoji < BlockKit::Base
      self.type = :emoji

      attribute :name, :string
      attribute :unicode, :string

      validates :name, presence: true
      validates :unicode, presence: true, format: {with: /\A[0-9a-f-]+\z/}, allow_nil: true
      fixes :unicode, null_value: {error_types: [:blank]}

      def unicode=(value)
        super(value&.to_s&.downcase)
      end

      def as_json(*)
        super.merge(
          name: name,
          unicode: unicode
        ).compact
      end
    end
  end
end
