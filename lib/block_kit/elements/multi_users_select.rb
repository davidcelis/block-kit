# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiUsersSelect < MultiSelect
      self.type = :multi_users_select

      attribute :initial_users, Types::Array.of(:string)

      def as_json(*)
        super.merge(initial_users: initial_users).compact
      end
    end
  end
end
