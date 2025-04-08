# frozen_string_literal: true

module BlockKit
  module Composition
    class DispatchActionConfiguration < Block
      VALID_TRIGGERS = [
        ON_ENTER_PRESSED = "on_enter_pressed",
        ON_CHARACTER_ENTERED = "on_character_entered"
      ].freeze

      attr_reader :trigger_actions_on

      validates :trigger_actions_on, presence: true, "block_kit/validators/array_inclusion": {in: VALID_TRIGGERS}

      def initialize(trigger_actions_on: [])
        super

        self.trigger_actions_on = trigger_actions_on
      end

      def trigger_actions_on=(values)
        @trigger_actions_on = if values
          Array(values).map(&:to_s)
        end
      end

      def as_json(*)
        {
          trigger_actions_on: trigger_actions_on
        }
      end
    end
  end
end
