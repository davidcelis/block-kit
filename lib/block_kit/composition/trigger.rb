# frozen_string_literal: true

module BlockKit
  module Composition
    class Trigger < Block
      attribute :url, :string
      attr_reader :customizable_input_parameters

      self.required_attributes = [:url]

      validates :url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https])}

      def initialize(attributes = {})
        customizable_input_parameters = attributes.delete(:customizable_input_parameters)

        super

        self.customizable_input_parameters = customizable_input_parameters
      end

      def customizable_input_parameters=(items)
        @customizable_input_parameters = if items
          Array(items).map { |item| Types::InputParameter.instance.cast(item) }.compact
        end
      end

      def as_json(*)
        {
          url: url,
          customizable_input_parameters: customizable_input_parameters&.map(&:as_json)
        }.compact
      end
    end
  end
end
