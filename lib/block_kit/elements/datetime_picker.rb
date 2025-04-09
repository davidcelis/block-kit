# frozen_string_literal: true

module BlockKit
  module Elements
    class DatetimePicker < Base
      TYPE = "datetimepicker"

      include Concerns::Confirmable
      include Concerns::FocusableOnLoad

      attribute :initial_date_time, :datetime
      alias_attribute :initial_datetime, :initial_date_time

      validates :initial_date_time, presence: true, allow_nil: true

      def as_json(*)
        super.merge(initial_date_time: initial_date_time&.to_i).compact
      end
    end
  end
end
