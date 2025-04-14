# frozen_string_literal: true

module BlockKit
  module Concerns
    module External
      extend ActiveSupport::Concern

      included do
        attribute :min_query_length, :integer
        validates :min_query_length, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
      end

      def as_json(*)
        super.merge(min_query_length: min_query_length).compact
      end
    end
  end
end
