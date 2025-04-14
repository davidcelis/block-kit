# frozen_string_literal: true

module BlockKit
  module Composition
    class DispatchActionConfig < Block
      self.type = :dispatch_action_config

      VALID_TRIGGERS = [
        ON_ENTER_PRESSED = "on_enter_pressed",
        ON_CHARACTER_ENTERED = "on_character_entered"
      ].freeze

      attribute :trigger_actions_on, Types::Set.of(:string)
      validates :trigger_actions_on, presence: true, "block_kit/validators/array_inclusion": {in: VALID_TRIGGERS}

      VALID_TRIGGERS.each do |value|
        define_method(:"trigger_actions_on_#{value}?") do
          !!trigger_actions_on&.member?(value)
        end

        define_method(:"trigger_actions_on_#{value}!") do
          self.trigger_actions_on ||= []
          self.trigger_actions_on.add(value)
        end
      end

      def as_json(*)
        {
          trigger_actions_on: trigger_actions_on&.to_a
        }
      end
    end
  end
end
