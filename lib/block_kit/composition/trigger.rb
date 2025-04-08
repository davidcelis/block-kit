# frozen_string_literal: true

module BlockKit
  module Composition
    class Trigger < Block
      attribute :url, :string
      attribute :customizable_input_parameters, Types::Array.of(Types::InputParameter.instance)

      self.required_attributes = [:url]

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true}
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
