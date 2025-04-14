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
          end

          def option(text:, value:, description: nil, initial: nil, emoji: nil)
            self.options ||= []
            options << Composition::Option.new(text: text, value: value, description: description, initial: initial, emoji: emoji)

            self
          end

          def as_json(*)
            super.merge(options: options&.map(&:as_json))
          end
        end
      end
    end
  end
end
