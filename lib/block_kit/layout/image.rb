# frozen_string_literal: true

require "uri"

module BlockKit
  module Layout
    class Image < Base
      self.type = :image

      attribute :alt_text, :string
      attribute :image_url, :string
      attribute :slack_file, Types::Block.of_type(Composition::SlackFile)
      plain_text_attribute :title

      include Concerns::PlainTextEmojiAssignment.new(:title)

      validates :alt_text, presence: true, length: {maximum: 2000}
      validates :image_url, presence: true, length: {maximum: 3000}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "is not a valid URI", allow_blank: true}, allow_nil: true
      validates :title, presence: true, length: {maximum: 2000}, allow_nil: true
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
