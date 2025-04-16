# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Broadcast < BlockKit::Base
      self.type = :broadcast

      VALID_RANGES = [
        HERE = "here",
        EVERYONE = "everyone",
        CHANNEL = "channel"
      ].freeze

      attribute :range, :string
      validates :range, presence: true, inclusion: {in: VALID_RANGES}

      def as_json(*)
        super.merge(range: range).compact
      end
    end
  end
end
