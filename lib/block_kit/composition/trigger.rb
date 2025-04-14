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

      dsl_method :customizable_input_parameters, as: :customizable_input_parameter, required_fields: [:name, :value], yields: false

      alias_method :input_parameter, :customizable_input_parameter
      alias_method :customizable_input_param, :customizable_input_parameter
      alias_method :input_param, :customizable_input_parameter

      def as_json(*)
        {
          url: url,
          customizable_input_parameters: customizable_input_parameters&.map(&:as_json)
        }.compact
      end
    end
  end
end
