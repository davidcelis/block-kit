# frozen_string_literal: true

require "active_model"

module BlockKit
  class Block
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    class_attribute :type, default: nil

    def self.plain_text_attribute(name)
      attribute name, Types::Block.of_type(Composition::PlainText)

      define_method(name) do |attributes = {}|
        attributes = attributes.with_indifferent_access
        return super() unless attributes.key?(:text) || attributes.key?(:emoji)

        public_send(:"#{name}=", Composition::PlainText.new(attributes.slice(:text, :emoji)))
      end
    end

    def initialize(attributes = {})
      raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(Block)

      super
    end

    def as_json(*)
      {type: self.class.type.to_s}
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
  end
end
