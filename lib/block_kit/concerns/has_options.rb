# frozen_string_literal: true

module BlockKit
  module Concerns
    class HasOptions
      def self.new(limit:, select: nil, groups: 0)
        Module.new do
          extend ActiveSupport::Concern

          included do
            attribute :options, Types::Array.of(Composition::Option)
            validates :options, length: {maximum: limit, message: "is too long (maximum is %{count} options)"}, "block_kit/validators/associated": true

            validate :only_one_initial_option if select == :single

            if groups > 0
              attribute :option_groups, Types::Array.of(Composition::OptionGroup)
              validates :option_groups, length: {maximum: groups, message: "is too long (maximum is %{count} groups)"}, "block_kit/validators/associated": true

              validate :options_or_option_groups
            else
              validates :options, presence: true
            end
          end

          def option(text:, value:, description: nil, initial: nil, emoji: nil)
            options << Composition::Option.new(text: text, value: value, description: description, initial: initial, emoji: emoji)

            self
          end

          define_method :as_json do |*args|
            super(*args).merge(options: options&.map(&:as_json)).tap do |json|
              case select
              when :single
                json[:initial_option] = initial_option&.as_json&.presence
              when :multi
                json[:initial_options] = initial_options&.map(&:as_json)&.presence
              end
            end.compact
          end

          case select
          when :single
            define_method :initial_option do
              if groups > 0
                options&.find(&:initial?) || option_groups&.flat_map(&:options)&.find(&:initial?)
              else
                options&.find(&:initial?)
              end
            end
          when :multi
            define_method :initial_options do
              if groups > 0
                options&.select(&:initial?) || option_groups&.flat_map(&:options)&.select(&:initial?)
              else
                options&.select(&:initial?)
              end
            end
          end

          private

          if select == :single
            def only_one_initial_option
              if options.present? && options.count(&:initial?) > 1
                options.each_with_index do |option, index|
                  errors.add("options[#{index}]", "can't be initial when other options are also as initial") if option.initial?
                end
              end
            end
          end

          if groups > 0
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
end
