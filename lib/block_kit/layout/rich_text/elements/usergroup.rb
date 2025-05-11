# frozen_string_literal: true

module BlockKit
  module Layout
    class RichText::Elements::Usergroup < BlockKit::Base
      self.type = :Usergroup

      attribute :usergroup_id, :string
      attribute :style, Types::Generic.of_type(RichText::Elements::MentionStyle)

      alias_attribute :user_group_id, :usergroup_id
      alias_attribute :id, :usergroup_id

      validates :usergroup_id, presence: true

      def as_json(*)
        super.merge(
          usergroup_id: usergroup_id,
          style: style&.as_json
        ).compact
      end
    end

    RichText::Elements::UserGroup = RichText::Elements::Usergroup
  end
end
