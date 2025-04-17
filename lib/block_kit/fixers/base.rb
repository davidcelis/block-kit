# frozen_string_literal: true

module BlockKit
  module Fixers
    class Base
      include ActiveSupport::Callbacks

      def initialize(attribute:, **options)
        @attribute = attribute.to_sym
        @dangerous = options.delete(:dangerous)
      end

      def fix(model, fixing_dangerously: false)
        raise NotImplementedError, "#{self.class} must implement `fix'"
      end

      def dangerous?
        !!@dangerous
      end

      private

      attr_reader :attribute

      def errors_for(model)
        Array(model.errors.group_by_attribute[attribute])
      end
    end
  end
end
