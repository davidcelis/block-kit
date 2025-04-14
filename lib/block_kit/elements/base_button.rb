# frozen_string_literal: true

module BlockKit
  module Elements
    class BaseButton < Base
      self.type = :button

      plain_text_attribute :text
      attribute :style, :string
      attribute :accessibility_label, :string

      include Concerns::PlainTextEmojiAssignment.new(:text)

      validates :text, presence: true, length: {maximum: 75}
      validates :style, presence: true, inclusion: {in: %w[primary danger]}, allow_nil: true
      validates :accessibility_label, presence: true, length: {maximum: 75}, allow_nil: true

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(BaseButton)

        super
      end

      def as_json(*)
        super.merge(
          text: text&.as_json,
          style: style,
          accessibility_label: accessibility_label
        ).compact
      end
    end
  end
end
