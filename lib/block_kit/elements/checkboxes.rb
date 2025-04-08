# frozen_string_literal: true

require "uri"

module BlockKit
  module Elements
    class Checkboxes < Base
      TYPE = "checkboxes"

      include Concerns::Confirmable
      include Concerns::HasOptions.with_limit(10)

      attribute :focus_on_load, :boolean

      def as_json(*)
        super.merge(
          initial_options: options&.select(&:initial?)&.map(&:as_json),
          focus_on_load: focus_on_load
        ).compact
      end
    end
  end
end
