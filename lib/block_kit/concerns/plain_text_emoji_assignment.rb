# frozen_string_literal: true

module BlockKit
  module Concerns
    module PlainTextEmojiAssignment
      def self.new(*attributes)
        Module.new do
          define_method(:initialize) do |attrs = {}, &block|
            raise ArgumentError, "expected `attributes' to be a Hash, got #{attrs.class}" unless attrs.is_a?(Hash)

            emoji = attrs.delete(:emoji)

            super(attrs, &block)

            unless emoji.nil?
              attributes.each do |attribute|
                text = public_send(attribute)
                public_send(:"#{attribute}=", Composition::PlainText.new) if text.nil?
                public_send(attribute).emoji = emoji
              end
            end
          end

          attributes.each do |attribute|
            define_method(:"#{attribute}=") do |value|
              # Attempt to preserve the existing text object's emoji attribute if present
              text = public_send(attribute)
              if !text&.emoji.nil? && value.is_a?(String)
                value = Composition::PlainText.new(text: value, emoji: text.emoji)
              end

              super(value)
            end
          end
        end
      end
    end
  end
end
