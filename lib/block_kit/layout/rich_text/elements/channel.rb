# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Channel < Block
      self.type = :channel

      attribute :channel_id, :string
      attribute :style, Types::Block.of_type(RichText::Elements::MentionStyle)

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
