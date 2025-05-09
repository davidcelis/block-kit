# frozen_string_literal: true

require "active_model"

module BlockKit
  module Types
    # Provides a way to generate generic ActiveModel types for individual block types.
    # Most block types can simply be cast from an object of the same type or a Hash with
    # the object's attributes.
    class Generic < ActiveModel::Type::Value
      class_attribute :instances, default: {}

      def self.new(block_class)
        instances[block_class] ||= super
      end

      class << self
        alias_method :of_type, :new
      end

      # These block types have special casting logic.
      instances[Composition::Text] = Text.instance
      instances[Composition::PlainText] = PlainText.instance
      instances[Composition::Mrkdwn] = Mrkdwn.instance
      instances[Composition::Option] = Option.instance
      instances[Composition::OverflowOption] = OverflowOption.instance

      attr_reader :type, :block_class

      def initialize(block_class)
        @block_class = block_class
        @type = :"block_kit_#{block_class.type}"
      end

      def cast(value)
        case value
        when block_class
          value
        when Hash
          block_class.new(**value.with_indifferent_access.slice(*block_class.attribute_names).symbolize_keys)
        end
      end
    end
  end
end
