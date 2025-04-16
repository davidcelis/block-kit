# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasOptions
      def self.new(limit:)
        Module.new do
          extend ActiveSupport::Concern

          included do
            attribute :options, Types::Array.of(Composition::Option)
            validates :options,
              presence: {unless: ->(block) { block.respond_to?(:option_groups) }},
              length: {maximum: limit, message: "is too long (maximum is %{count} options)"},
              "block_kit/validators/associated": true
            fixes :options, associated: true

            dsl_method :options, as: :option, required_fields: [:text, :value], yields: false
          end

          def as_json(*)
            super.merge(options: options&.map(&:as_json))
          end
        end
      end
    end
  end
end
