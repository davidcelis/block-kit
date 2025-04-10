# frozen_string_literal: true

module BlockKit
  module Elements
    class Select < Base
      include Concerns::Confirmable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      def initialize(attributes = {})
        raise NotImplementedError, "#{self} is an abstract class and cannot be instantiated." if instance_of?(Select)

        super
      end
    end
  end
end
