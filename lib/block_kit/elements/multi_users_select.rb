# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiUsersSelect < MultiSelect
      self.type = :multi_users_select

      attribute :initial_users, Types::Set.of(:string)
      validate :initial_users_are_all_present
      fix :remove_blank_initial_users

      def as_json(*)
        super.merge(initial_users: initial_users&.to_a).compact
      end

      private

      def initial_users_are_all_present
        if Array(initial_users).any?(&:blank?)
          errors.add(:initial_users, "must not contain blank values")
        end
      end

      def remove_blank_initial_users
        return unless initial_users.present?

        initial_users.reject!(&:blank?)
      end
    end
  end
end
