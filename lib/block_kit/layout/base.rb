# frozen_string_literal: true

require_relative "../block"

module BlockKit
  module Layout
    class Base < Block
      attribute :block_id, :string
      validates :block_id, allow_blank: true, length: {maximum: 255}

      def as_json(*)
        super.merge(block_id: block_id).compact
      end
    end
  end
end
