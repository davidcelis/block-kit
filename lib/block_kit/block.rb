# frozen_string_literal: true

require "active_model"

module BlockKit
  class Block
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    class_attribute :type, default: nil

    def initialize(attributes = {})
      raise NotImplementedError, "#{self.class} is an abstract class and cannot be instantiated." if instance_of?(Block)

      super
    end

    def as_json(*)
      {type: self.class.type.to_s}
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
