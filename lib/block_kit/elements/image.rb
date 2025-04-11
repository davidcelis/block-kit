# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class Image < Block
      self.type = :image

      attribute :alt_text, :string
      attribute :image_url, :string
      attribute :slack_file, Types::Block.of_type(Composition::SlackFile)

      validates :alt_text, presence: true
      validates :image_url, presence: true, length: {maximum: 3000}, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "is not a valid URI", allow_blank: true}, allow_nil: true

      validate :slack_file_or_url_present

      def as_json(*)
        super.merge(
          alt_text: alt_text,
          image_url: image_url,
          slack_file: slack_file&.as_json
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
