# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiChannelsSelect < MultiSelect
      self.type = :multi_channels_select

      attribute :initial_channels, Types::Set.of(:string)
      validate :initial_channels_are_all_present
      fix :remove_blank_initial_channels

      def as_json(*)
        super.merge(initial_channels: initial_channels&.to_a).compact
      end

      private

      def initial_channels_are_all_present
        if Array(initial_channels).any?(&:blank?)
          errors.add(:initial_channels, "must not contain blank values")
        end
      end

      def remove_blank_initial_channels
        return unless initial_channels.present?

        initial_channels.reject!(&:blank?)
      end
    end
  end
end
