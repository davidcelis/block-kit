# frozen_string_literal: true

module BlockKit
  module Elements
    class UsersSelect < Select
      self.type = :users_select

      attribute :initial_user, :string

      def as_json(*)
        super.merge(initial_user: initial_user).compact
      end
    end
  end
end
