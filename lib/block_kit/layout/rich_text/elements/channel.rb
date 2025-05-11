# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Channel < BlockKit::Base
      self.type = :channel

      attribute :channel_id, :string
      attribute :style, Types::Generic.of_type(RichText::Elements::MentionStyle)

      alias_attribute :id, :channel_id

      validates :channel_id, presence: true

      def as_json(*)
        super.merge(
          channel_id: channel_id,
          style: style&.as_json
        ).compact
      end
    end
  end
end
