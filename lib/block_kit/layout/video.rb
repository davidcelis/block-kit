# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class Video < Base
      self.type = :video

      attribute :alt_text, :string
      attribute :author_name, :string
      attribute :description, Types::Block.of_type(Composition::PlainText)
      attribute :provider_icon_url, :string
      attribute :provider_name, :string
      attribute :title, Types::Block.of_type(Composition::PlainText)
      attribute :title_url, :string
      attribute :thumbnail_url, :string
      attribute :video_url, :string

      validates :alt_text, presence: true, length: {maximum: 2000}
      validates :author_name, presence: true, length: {maximum: 50}, allow_nil: true
      validates :description, presence: true, length: {maximum: 200}, allow_nil: true
      validates :provider_icon_url, presence: true, length: {maximum: 3000}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https http]), message: "is not a valid URI"}, allow_nil: true
      validates :provider_name, presence: true, length: {maximum: 50}, allow_nil: true
      validates :title, presence: true, length: {maximum: 200}
      validates :title_url, presence: true, length: {maximum: 3000}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https]), message: "is not a valid HTTPS URI"}, allow_nil: true
      validates :thumbnail_url, presence: true, length: {maximum: 3000}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https http]), message: "is not a valid URI"}
      validates :video_url, presence: true, length: {maximum: 3000}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https]), message: "is not a valid HTTPS URI"}

      def as_json(*)
        super.merge(
          alt_text: alt_text,
          author_name: author_name,
          description: description&.as_json,
          provider_icon_url: provider_icon_url,
          provider_name: provider_name,
          title: title&.as_json,
          title_url: title_url,
          thumbnail_url: thumbnail_url,
          video_url: video_url
        ).compact
      end
    end
  end
end
