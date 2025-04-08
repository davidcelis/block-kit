# frozen_string_literal: true

module BlockKit
  module Concerns
    class HasOptions
      def self.with_limit(limit)
        Module.new do
          extend ActiveSupport::Concern

          included do
            attribute :options, Types::Array.of(Types::Option.instance)

            validates :options, presence: true, length: {maximum: limit, message: "is too long (maximum is %{count} options)"}, "block_kit/validators/associated": true
          end

          def as_json(*)
            super.merge(options: options&.map(&:as_json)).compact
          end
        end
      end
    end
  end
end
