# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiChannelsSelect < MultiSelect
      self.type = :multi_channels_select

      attribute :initial_channels, Types::Set.of(:string)

      def as_json(*)
        super.merge(initial_channels: initial_channels&.to_a).compact
      end
    end
  end
end
