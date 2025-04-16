# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Color < BlockKit::Base
      self.type = :color

      attribute :value, :string

      # Slack accepts both hex codes _and_ extended CSS3 color names. However,
      # they don't actually validate that the value is a real color; they just
      # display white if it isn't, while allowing the block itself to be valid.
      validates :value, presence: true

      def as_json(*)
        super.merge(value: value).compact
      end
    end
  end
end
