# frozen_string_literal: true

require "active_model"

module BlockKit
  module Layout
    class Divider
      TYPE = "divider"

      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attribute :block_id, :string

      validates :block_id, allow_blank: true, length: {maximum: 255}

      def as_json(*)
        {
          type: TYPE,
          block_id: block_id
        }.compact
      end
    end
  end
end
