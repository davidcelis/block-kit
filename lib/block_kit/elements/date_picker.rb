# frozen_string_literal: true

module BlockKit
  module Elements
    class DatePicker < Base
      self.type = :datepicker

      include Concerns::Confirmable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder

      attribute :initial_date, :date

      validates :initial_date, presence: true, allow_nil: true

      def as_json(*)
        super.merge(initial_date: initial_date&.iso8601).compact
      end
    end
  end
end
