# frozen_string_literal: true

module BlockKit
  module Elements
    class DatePicker < Base
      TYPE = "date_picker"

      include Concerns::Confirmable

      attribute :initial_date, :date
      attribute :focus_on_load, :boolean
      attribute :placeholder, Types::PlainText.instance

      validates :initial_date, presence: true, allow_nil: true
      validates :placeholder, presence: true, length: {maximum: 150}, allow_nil: true

      def as_json(*)
        super.merge(
          initial_date: initial_date&.iso8601,
          focus_on_load: focus_on_load,
          placeholder: placeholder&.as_json
        ).compact
      end
    end
  end
end
