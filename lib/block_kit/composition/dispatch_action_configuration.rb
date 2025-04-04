# frozen_string_literal: true

module BlockKit
  module Composition
    class DispatchActionConfiguration < Block
      VALID_TRIGGERS = %w[on_enter_pressed on_character_entered].freeze

      attr_reader :trigger_actions_on

      validates :trigger_actions_on, presence: true, "block_kit/validators/array_inclusion": {in: VALID_TRIGGERS}

      def initialize(trigger_actions_on:)
        super

        self.trigger_actions_on = trigger_actions_on
      end

      def trigger_actions_on=(value)
        @trigger_actions_on = Array(value).map(&:to_s)
      end

      def as_json(*)
        {
          trigger_actions_on: trigger_actions_on
        }.compact
      end
    end
  end
end
