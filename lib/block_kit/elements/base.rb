# frozen_string_literal: true

module BlockKit
  module Elements
    class Base < Block
      attribute :action_id, :string

      validates :action_id, presence: true, length: {maximum: 255}, allow_nil: true

      def as_json(*)
        super.merge(action_id: action_id).compact
      end
    end
  end
end
