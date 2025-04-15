# frozen_string_literal: true

module BlockKit
  module Validators
    # Allows using Rails' `validates_associated` method for ActiveModel models.
    # The built-in validator only supports ActiveRecord models.
    #
    # See: https://github.com/rails/rails/blob/main/activerecord/lib/active_record/validations/associated.rb
    class AssociatedValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if value.is_a?(Array)
          if value.any?(&:invalid?)
            record.errors.add(attribute, :invalid, **options, value: value, invalid_values: value.select(&:invalid?))
          end

          value.each_with_index do |item, i|
            unless item.valid?
              error_messages = build_error_messages(item.errors)
              record.errors.add("#{attribute}[#{i}]", "is invalid: #{error_messages.join(", ")}", **options, value: item)
            end
          end
        elsif value.present? && value.invalid?
          error_messages = build_error_messages(value.errors)
          record.errors.add(attribute, "is invalid: #{error_messages.join(", ")}", **options, value: value)
        end
      end

      private

      def build_error_messages(errors, prefix = nil)
        messages = []

        errors.group_by_attribute.each do |attribute, error_details|
          error_details.each do |error|
            # If the message starts with "is invalid: ", it indicates a nested
            # error from a more deeply nested model. We'll parse it to extract
            # each comma-separated message and format it with the full path.
            if error.message.start_with?("is invalid: ")
              error.message.sub(/^is invalid:\s*/, "").split(", ").each do |nested_error|
                if nested_error.include?(" ")
                  path, message = nested_error.split(" ", 2)
                  full_path = [prefix, attribute, path].compact.join(".")
                  messages << "#{full_path} #{message}"
                else
                  # Fallback for unexpected format
                  full_path = [prefix, attribute].compact.join(".")
                  messages << "#{full_path} #{nested_error}"
                end
              end
            else
              full_path = [prefix, attribute].compact.join(".")
              messages << "#{full_path} #{error.message}"
            end
          end
        end

        messages
      end
    end
  end
end
