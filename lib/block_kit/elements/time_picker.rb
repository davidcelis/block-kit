# frozen_string_literal: true

module BlockKit
  module Elements
    class TimePicker < Base
      self.type = :timepicker

      include Concerns::Confirmable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      attribute :initial_time, :time, precision: 0
      attribute :timezone, :string

      validate :timezone_is_valid

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
        return errors.add(:timezone, "can't be blank") if attributes["timezone"].blank?

        errors.add(:timezone, "is not a valid timezone") unless ActiveSupport::TimeZone[attributes["timezone"]]
      end
    end
  end
end
