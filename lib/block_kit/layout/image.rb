# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class Image < Base
      MAX_ALT_TEXT_LENGTH = 2000
      MAX_IMAGE_URL_LENGTH = 3000
      MAX_TITLE_LENGTH = 2000

      self.type = :image

      attribute :alt_text, :string
      attribute :image_url, :string
      attribute :slack_file, Types::Generic.of_type(Composition::SlackFile)
      plain_text_attribute :title

      alias_attribute :url, :image_url

      include Concerns::PlainTextEmojiAssignment.new(:title)

      validates :alt_text, presence: true, length: {maximum: MAX_ALT_TEXT_LENGTH}
      fixes :alt_text, truncate: {maximum: MAX_ALT_TEXT_LENGTH}

      validates :image_url, presence: true, length: {maximum: MAX_IMAGE_URL_LENGTH}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "is not a valid URI", allow_blank: true}, allow_nil: true
      fixes :image_url, truncate: {maximum: MAX_IMAGE_URL_LENGTH, dangerous: true, omission: ""}, null_value: {error_types: [:blank]}

      validates :title, presence: true, length: {maximum: MAX_TITLE_LENGTH}, allow_nil: true
      fixes :title, truncate: {maximum: MAX_TITLE_LENGTH}, null_value: {error_types: [:blank]}

      validate :slack_file_or_url_present

      def slack_file(attrs = {})
        attrs = attrs.with_indifferent_access
        return super() unless attrs.key?(:id) || attrs.key?(:url)

        raise ArgumentError, "mutually exclusive keywords: :id, :url" if attrs.key?(:id) && attrs.key?(:url)

        self.slack_file = Composition::SlackFile.new(**attrs.slice(:id, :url))

        self
      end

      def as_json(*)
        super.merge(
          alt_text: alt_text,
          image_url: image_url,
          slack_file: slack_file&.as_json,
          title: title&.as_json
        ).compact
      end

      private

      def slack_file_or_url_present
        if (slack_file.nil? && image_url.nil?) || (slack_file.present? && image_url.present?)
          errors.add(:base, "must have either a slack_file or image_url but not both")
        end
      end
    end
  end
end
