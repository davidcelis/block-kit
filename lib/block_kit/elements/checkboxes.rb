# frozen_string_literal: true

module BlockKit
  module Elements
    class Checkboxes < Base
      TYPE = "checkboxes"

      include Concerns::Confirmable
      include Concerns::HasOptions.with_limit(10)
      include Concerns::FocusableOnLoad

      def as_json(*)
        super.merge(
          initial_options: initial_options&.map(&:as_json)
        ).compact
      end

      private

      def initial_options
        options.select(&:initial?)
      end
    end
  end
end
