# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiExternalSelect < MultiSelect
      self.type = :multi_external_select

      include Concerns::External

      attribute :initial_options, Types::Array.of(Composition::Option)
      validates :initial_options, "block_kit/validators/associated": true, allow_nil: true

      def as_json(*)
        super.merge(initial_options: initial_options&.map(&:as_json)).compact
      end
    end
  end
end
