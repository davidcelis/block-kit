# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiExternalSelect < MultiSelect
      self.type = :multi_external_select

      attribute :initial_options, Types::Array.of(Composition::Option)
      attribute :min_query_length, :integer

      validates :min_query_length, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

      def as_json(*)
        super.merge(
          initial_options: initial_options&.map(&:as_json),
          min_query_length: min_query_length
        ).compact
      end
    end
  end
end
