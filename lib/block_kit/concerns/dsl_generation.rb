# frozen_string_literal: true

module BlockKit
  module Concerns
    module DSLGeneration
      extend ActiveSupport::Concern

      class_methods do
        private

        def dsl_method(attribute, as: nil, type: nil, required_fields: [], mutually_exclusive_fields: [], yields: true)
          type ||= attribute_types[attribute.to_s]
          type = Types::Generic.of_type(type) if type.is_a?(Class) && type < BlockKit::Base
          raise ArgumentError, "attribute #{attribute} does not exist" if type.instance_of?(ActiveModel::Type::Value)

          is_array_attribute = false

          if type.instance_of?(Types::Array)
            is_array_attribute = true
            type = type.item_type
          end

          is_array_attribute ||= attribute_types[attribute.to_s].type == :array

          fields = type.block_class.attribute_names.map(&:to_sym)
          plain_text_fields = type.block_class.attribute_types.select { |_, v| v.respond_to?(:block_class) && v.block_class == Composition::PlainText }.keys.map(&:to_sym)

          define_method(as || attribute) do |args = {}, &block|
            args = args.symbolize_keys

            # Return the existing attribute if no args or block are passed and we're not in a custom-named method
            return super() if args.blank? && block.nil? && as.nil?

            if (missing_required_fields = (required_fields - args.keys)) && missing_required_fields.any?
              message = "missing keyword#{"s" if missing_required_fields.size > 1}: #{missing_required_fields.map(&:inspect).join(", ")}"
              raise ArgumentError, message
            end

            unknown_fields = (args.keys - fields)
            unknown_fields.delete(:emoji) if plain_text_fields.any?

            if unknown_fields.any?
              message = "unknown keyword#{"s" if unknown_fields.size > 1}: #{unknown_fields.map(&:inspect).join(", ")}"
              raise ArgumentError, message
            end

            mutually_exclusive = mutually_exclusive_fields & args.keys
            if mutually_exclusive.length > 1
              message = "mutually exclusive keywords: #{mutually_exclusive.map(&:inspect).join(", ")}"
              raise ArgumentError, message
            end

            new_value = if is_array_attribute
              public_send(:"#{attribute}=", []) if public_send(attribute).nil?
              public_send(attribute) << type.cast(args)
              public_send(attribute).last
            else
              public_send(:"#{attribute}=", type.cast(args))
              public_send(attribute)
            end

            plain_text_fields.each do |field|
              next unless args.key?(field)

              new_value.public_send(field).emoji = args[:emoji] if args.key?(:emoji)
            end

            block&.call(new_value) if yields

            self
          end
        end
      end
    end
  end
end
