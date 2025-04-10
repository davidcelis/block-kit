# frozen_string_literal: true

module BlockKit
  module Elements
    class ChannelsSelect < Select
      self.type = :channels_select

      attribute :initial_channel, :string
      attribute :response_url_enabled, :boolean

      def as_json(*)
        super.merge(
          initial_channel: initial_channel,
          response_url_enabled: response_url_enabled
        ).compact
      end
    end
  end
end
