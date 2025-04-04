# frozen_string_literal: true

require_relative "../block"
require_relative "plain_text"

module BlockKit
  module Composition
    class Dialog < Block
      attribute :title, Types::PlainTextBlock.new
      attribute :text, Types::PlainTextBlock.new
      attribute :confirm, Types::PlainTextBlock.new
      attribute :deny, Types::PlainTextBlock.new
      attribute :style, :string

      validates :title, presence: true, length: {maximum: 100, allow_blank: true}
      validates :text, presence: true, length: {maximum: 300, allow_blank: true}
      validates :confirm, presence: true, length: {maximum: 30, allow_blank: true}
      validates :deny, presence: true, length: {maximum: 30, allow_blank: true}
      validates :style, inclusion: {in: %w[primary danger], allow_blank: true}

      def as_json(*)
        {
          title: title.as_json,
          text: text.as_json,
          confirm: confirm.as_json,
          deny: deny.as_json,
          style: style
        }.compact
      end
    end
  end
end
