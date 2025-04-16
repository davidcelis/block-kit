# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::User < BlockKit::Base
      self.type = :user

      attribute :user_id, :string
      attribute :style, Types::Generic.of_type(RichText::Elements::MentionStyle)

      validates :user_id, presence: true

      def as_json(*)
        super.merge(
          user_id: user_id,
          style: style&.as_json
        ).compact
      end
    end
  end
end
