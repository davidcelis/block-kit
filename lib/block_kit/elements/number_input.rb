# frozen_string_literal: true

module BlockKit
  module Elements
    class NumberInput < Base
      self.type = :number_input

      include Concerns::FocusableOnLoad

      attribute :dispatch_action_config, Types::Block.of_type(Composition::DispatchActionConfig)
      attribute :placeholder, Types::PlainText.instance

      alias_attribute :dispatch_action_configuration, :dispatch_action_config

      validates :dispatch_action_config, presence: true, "block_kit/validators/associated": true, allow_nil: true
      validates :placeholder, presence: true, length: {maximum: 150}, allow_nil: true

      def initialize(attributes = {})
        if instance_of?(NumberInput)
          raise NotImplementedError, "#{self} is an abstract class and cannot be instantiated. You must explicitly instantiate an IntegerInput or DecimalInput."
        else
          super
        end
      end

      def as_json(*)
        super.merge(
          dispatch_action_config: dispatch_action_config&.as_json,
          placeholder: placeholder&.as_json
        ).compact
      end
    end
  end
end
