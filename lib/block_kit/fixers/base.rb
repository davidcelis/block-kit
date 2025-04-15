# frozen_string_literal: true

module BlockKit
  module Fixers
    class Base
      include ActiveSupport::Callbacks

      def initialize(attribute:)
        @attribute = attribute.to_sym
      end

      def fix(model)
        raise NotImplementedError, "#{self.class} must implement `fix'"
      end

      private

      attr_reader :attribute

      def errors_for(model)
        Array(model.errors.group_by_attribute[attribute])
      end
    end
  end
end
