# frozen_string_literal: true

module BlockKit
  module Elements
    class ExternalSelect < Select
      self.type = :external_select

      include Concerns::External

      attribute :initial_option, Types::Block.of_type(Composition::Option)

      validates :initial_option, "block_kit/validators/associated": true, allow_nil: true

      def as_json(*)
        super.merge(initial_option: initial_option&.as_json).compact
      end
    end
  end
end
