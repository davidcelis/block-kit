# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class Video < Base
      MAX_ALT_TEXT_LENGTH = 2000
      MAX_AUTHOR_NAME_LENGTH = 50
      MAX_DESCRIPTION_LENGTH = 200
      MAX_URL_LENGTH = 3000
      MAX_PROVIDER_NAME_LENGTH = 50
      MAX_TITLE_LENGTH = 200

      self.type = :video

      attribute :alt_text, :string
      attribute :author_name, :string
      plain_text_attribute :description
      attribute :provider_icon_url, :string
      attribute :provider_name, :string
      plain_text_attribute :title
      attribute :title_url, :string
      attribute :thumbnail_url, :string
      attribute :video_url, :string

      include Concerns::PlainTextEmojiAssignment.new(:description, :title)

      validates :alt_text, presence: true, length: {maximum: MAX_ALT_TEXT_LENGTH}
      fixes :alt_text, truncate: {maximum: MAX_ALT_TEXT_LENGTH}

      validates :author_name, presence: true, length: {maximum: MAX_AUTHOR_NAME_LENGTH}, allow_nil: true
      fixes :author_name, truncate: {maximum: MAX_AUTHOR_NAME_LENGTH}, null_value: {error_types: [:blank]}

      validates :description, presence: true, length: {maximum: MAX_DESCRIPTION_LENGTH}, allow_nil: true
      fixes :description, truncate: {maximum: MAX_DESCRIPTION_LENGTH}, null_value: {error_types: [:blank]}

      validates :provider_icon_url, presence: true, length: {maximum: MAX_URL_LENGTH}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https http]), message: "is not a valid URI"}, allow_nil: true
      fixes :provider_icon_url, truncate: {maximum: MAX_URL_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

      validates :provider_name, presence: true, length: {maximum: MAX_PROVIDER_NAME_LENGTH}, allow_nil: true
      fixes :provider_name, truncate: {maximum: MAX_PROVIDER_NAME_LENGTH}, null_value: {error_types: [:blank]}

      validates :title, presence: true, length: {maximum: MAX_TITLE_LENGTH}
      fixes :title, truncate: {maximum: MAX_TITLE_LENGTH}

      validates :title_url, presence: true, length: {maximum: MAX_URL_LENGTH}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https]), message: "is not a valid HTTPS URI"}, allow_nil: true
      fixes :title_url, truncate: {maximum: MAX_URL_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

      validates :thumbnail_url, presence: true, length: {maximum: MAX_URL_LENGTH}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https http]), message: "is not a valid URI"}
      fixes :thumbnail_url, truncate: {maximum: MAX_URL_LENGTH, dangerous: true, omission: ""}

      validates :video_url, presence: true, length: {maximum: MAX_URL_LENGTH}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[https]), message: "is not a valid HTTPS URI"}
      fixes :video_url, truncate: {maximum: MAX_URL_LENGTH, dangerous: true, omission: ""}

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
