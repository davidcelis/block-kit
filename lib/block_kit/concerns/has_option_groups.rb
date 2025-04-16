# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasOptionGroups
      def self.new(limit:, options_limit:)
        Module.new do
          extend ActiveSupport::Concern

          included do
            include HasOptions.new(limit: options_limit)

            attribute :option_groups, Types::Array.of(Composition::OptionGroup)
            validates :option_groups, length: {maximum: limit, message: "is too long (maximum is %{count} groups)"}, "block_kit/validators/associated": true
            fixes :option_groups, associated: true

            validate :options_or_option_groups

            dsl_method :option_groups, as: :option_group, required_fields: [:label]
          end

          def as_json(*)
            super.merge(option_groups: option_groups&.map(&:as_json)).compact
          end

          private

          def options_or_option_groups
            if (options.blank? && option_groups.blank?) || (options.present? && option_groups.present?)
              errors.add(:base, "must have either options or option groups, not both")
            end
          end
        end
      end
    end
  end
end
