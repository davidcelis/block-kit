# frozen_string_literal: true

module BlockKit
  module Elements
    class ExternalSelect < MultiSelect
      self.type = :external_select

      include Concerns::External

      attribute :initial_option, Types::Block.of_type(Composition::Option)

      def as_json(*)
        super.merge(initial_option: initial_option&.as_json).compact
      end
    end
  end
end
