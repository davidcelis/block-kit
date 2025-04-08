# frozen_string_literal: true

module BlockKit
  module Composition
    class DispatchActionConfiguration < Block
      VALID_TRIGGERS = [
        ON_ENTER_PRESSED = "on_enter_pressed",
        ON_CHARACTER_ENTERED = "on_character_entered"
      ].freeze

      attribute :trigger_actions_on, Types::Array.of(:string)

      validates :trigger_actions_on, presence: true, "block_kit/validators/array_inclusion": {in: VALID_TRIGGERS}

      def as_json(*)
        {
          trigger_actions_on: trigger_actions_on
        }
      end
    end
  end
end
