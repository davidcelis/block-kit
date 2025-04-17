# frozen_string_literal: true

module BlockKit
  module Elements
    class Overflow < Base
      MAX_OPTIONS = 5

      self.type = :overflow

      include Concerns::Confirmable

      attribute :options, Types::Array.of(Composition::OverflowOption)
      validates :options, presence: true, length: {maximum: MAX_OPTIONS, message: "is too long (maximum is %{count} options)"}, "block_kit/validators/associated": true
      fixes :options, truncate: {maximum: MAX_OPTIONS, dangerous: true}, associated: true

      dsl_method :options, as: :option, required_fields: [:text, :value], yields: false

      def as_json(*)
        super.merge(options: options&.map(&:as_json))
      end
    end
  end
end
