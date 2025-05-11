# frozen_string_literal: true

module BlockKit
  module Elements
    class TimePicker < Base
      self.type = :timepicker

      include Concerns::Confirmable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder
      include Concerns::PlainTextEmojiAssignment.new(:placeholder)

      attribute :initial_time, :time, precision: 0
      attribute :timezone, :string

      validate :timezone_is_valid
      fixes :timezone, null_value: {error_types: [:blank, :invalid]}

      def timezone
        ActiveSupport::TimeZone[super] if super
      end

      def as_json(*)
        super.merge(
          initial_time: initial_time&.strftime("%H:%M"),
          timezone: timezone&.name
        ).compact
      end

      private

      def timezone_is_valid
        return if attributes["timezone"].nil?

        if attributes["timezone"].blank?
          errors.add(:timezone, :blank)
        else
          errors.add(:timezone, :invalid, message: "is not a valid timezone") unless ActiveSupport::TimeZone[attributes["timezone"]]
        end
      end
    end

    Timepicker = TimePicker
  end
end
