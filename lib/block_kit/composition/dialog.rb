# frozen_string_literal: true

module BlockKit
  module Composition
    class Dialog < Block
      attribute :title, Types::PlainTextBlock.instance
      attribute :text, Types::PlainTextBlock.instance
      attribute :confirm, Types::PlainTextBlock.instance
      attribute :deny, Types::PlainTextBlock.instance
      attribute :style, :string

      validates :title, presence: true, length: {maximum: 100}
      validates :text, presence: true, length: {maximum: 300}
      validates :confirm, presence: true, length: {maximum: 30}
      validates :deny, presence: true, length: {maximum: 30}
      validates :style, presence: true, inclusion: {in: %w[primary danger]}, allow_nil: true

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
