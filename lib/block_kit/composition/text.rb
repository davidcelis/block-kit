# frozen_string_literal: true

module BlockKit
  module Composition
    class Text < Base
      MAX_LENGTH = 3000

      attribute :text, :string
      validates :text, presence: true, length: {maximum: MAX_LENGTH}
      fixes :text, truncate: {maximum: MAX_LENGTH}

      delegate :blank?, :present?, to: :text

      def self.inherited(subclass)
        subclass.attribute_fixers = attribute_fixers.deep_dup
      end

      def length
        text&.length || 0
      end

      def truncate(*)
        dup.tap do |copy|
          copy.text = text.truncate(*)
        end
      end

      def as_json(*)
        super.merge(text: text)
      end
    end
  end
end
