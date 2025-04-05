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
          value.each_with_index do |item, i|
            unless item.valid?
              record.errors.add("#{attribute}[#{i}]", invalid_message_for(item), **options, value: item)
            end
          end
        elsif value.present? && value.invalid?
          record.errors.add(attribute, invalid_message_for(value), **options, value: value)
        end
      end

      private

      def invalid_message_for(item)
        messages = item.errors.group_by_attribute.map do |attribute, errors|
          "#{attribute} #{errors.map(&:message).join(", ")}"
        end

        "is invalid: #{messages.join(", ")}"
      end
    end
  end
end
