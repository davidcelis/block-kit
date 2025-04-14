# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Usergroup < Block
      self.type = :Usergroup

      attribute :usergroup_id, :string
      attribute :style, Types::Block.of_type(RichText::Elements::MentionStyle)

      validates :usergroup_id, presence: true

      def as_json(*)
        super.merge(
          usergroup_id: usergroup_id,
          style: style&.as_json
        ).compact
      end
    end
  end
end
