# frozen_string_literal: true

module BlockKit
  module Elements
    class NumberInput < Base
      self.type = :number_input

      include Concerns::Dispatchable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      def initialize(attributes = {})
        if instance_of?(NumberInput)
          raise NotImplementedError, "#{self} is an abstract class and cannot be instantiated. You must explicitly instantiate an IntegerInput or DecimalInput."
        else
          super
        end
      end
    end
  end
end
