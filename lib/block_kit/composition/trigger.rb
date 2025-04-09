# frozen_string_literal: true

require "uri"

module BlockKit
  module Composition
    class Trigger < Block
      self.type = :trigger

      attribute :url, :string
      attribute :customizable_input_parameters, Types::Array.of(Composition::InputParameter)

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "is not a valid URI", allow_blank: true}
      validates :customizable_input_parameters, presence: true, "block_kit/validators/associated": true, allow_nil: true

      def as_json(*)
        {
          url: url,
          customizable_input_parameters: customizable_input_parameters&.map(&:as_json)
        }.compact
      end
    end
  end
end
