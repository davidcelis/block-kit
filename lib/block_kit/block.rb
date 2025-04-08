# frozen_string_literal: true

require "active_model"

module BlockKit
  class Block
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    class_attribute :required_attributes, default: []

    def initialize(attributes = {})
      missing_required_attributes = self.class.required_attributes - attributes.symbolize_keys.keys

      raise ArgumentError, "missing required attributes: #{missing_required_attributes.join(", ")}" if missing_required_attributes.any?

      super
    end

    def as_json(*)
      {type: self.class::TYPE}
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
