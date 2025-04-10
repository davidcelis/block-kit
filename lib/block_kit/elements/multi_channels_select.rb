# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiChannelsSelect < MultiSelect
      self.type = :multi_channels_select

      attribute :initial_channels, Types::Array.of(:string)

      def as_json(*)
        super.merge(initial_channels: initial_channels).compact
      end
    end
  end
end
