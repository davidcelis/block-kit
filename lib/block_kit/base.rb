# frozen_string_literal: true

require "active_model"
require "json"

module BlockKit
  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    class_attribute :type, default: nil
    class_attribute :attribute_fixers, default: Hash.new { |h, k| h[k] = [] }

    before_validation :fix_validation_errors, if: -> { BlockKit.config.autofix_on_validation && !fixing? }

    def self.fixes(attribute, fixers)
      fixers.each do |name, options|
        options = {} if !options.is_a?(Hash)
        fixer_class = BlockKit::Fixers.const_get(name.to_s.camelize)
        fixer = fixer_class.new(attribute: attribute, **options)

        attribute_fixers[attribute] << fixer
      end
    end

    def self.fix(method_name, dangerous: false)
      attribute_fixers[:base] << {name: method_name, dangerous: dangerous}
    end

    def self.inherited(subclass)
      subclass.attribute_fixers = attribute_fixers.deep_dup
    end

    def initialize(attributes = {})
      raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(Base)

      super

      yield(self) if block_given?
    end

    def fix_validation_errors(dangerous: BlockKit.config.autofix_dangerously)
      fixing do
        return true if valid?

        Array(attribute_fixers[:base]).each do |method|
          method(method[:name]).call unless method[:dangerous] && !dangerous
        end

        attribute_fixers.except(:base).each do |attribute, fixers|
          fixers.each { |fixer| fixer.fix(self, fixing_dangerously: dangerous) }
        end

        validate
      end
    end

    def fix_validation_errors!(dangerous: BlockKit.config.autofix_dangerously)
      fixing do
        fix_validation_errors(dangerous: dangerous)

        validate!
      end
    end

    def as_json(*)
      fix_validation_errors if BlockKit.config.autofix_on_render

      {type: self.class.type.to_s}
    end

    def to_json(*)
      as_json.to_json
    end

    def ==(other)
      other.instance_of?(self.class) && attributes == other.attributes
    end

    def self.inspect
      "#{name}(#{attribute_types.map { |k, v| "#{k}: #{v.type}" }.join(", ")})"
    end

    def inspect
      "#<#{self.class} #{attributes.map { |k, v| "#{k}: #{v.inspect}" }.join(", ")}>"
    end

    def pretty_print(pp)
      pp.object_group(self) do
        pp.breakable
        pp.seplist(attributes) do |k, v|
          pp.text "#{k}: "
          pp.pp v
        end
      end
    end

    private

    # The `fixing` instance variable is set to true when the object is being
    # autofixed. This is used to prevent infinite loops when the fixers modify
    # the object and trigger validation again.
    def fixing
      previous_value = @fixing

      @fixing = true

      yield
    ensure
      @fixing = previous_value
    end

    def fixing?
      !!@fixing
    end

    def self.plain_text_attribute(name)
      attribute name, Types::Generic.of_type(Composition::PlainText)

      dsl_method(name, required_fields: [:text], yields: false)
    end
    private_class_method :plain_text_attribute

    def self.dsl_method(attribute, as: nil, type: nil, required_fields: [], mutually_exclusive_fields: [], yields: true)
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
        # Convert any args that were passed as attribute aliases to the actual attribute name while keeping
        # the original arg names in case we need to reference them in a later error message.
        attribute_aliases = type.block_class.attribute_aliases
        args = args.transform_keys { |arg| attribute_aliases[arg.to_s] || arg } if attribute_aliases.any?
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
          # This is the only error message that might need to show original arg names
          # based on aliases; missing or unknown fields can't be affected.
          mutually_exclusive = mutually_exclusive.map { |arg| attribute_aliases.key(arg) || arg }

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
    private_class_method :dsl_method
  end
end
