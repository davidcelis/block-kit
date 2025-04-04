# frozen_string_literal: true

require_relative "text"
require_relative "plain_text"

module BlockKit
  module Composition
    class Mrkdwn < Text
      TYPE = "mrkdwn"

      attribute :verbatim, :boolean

      def as_json(*)
        super.merge(verbatim: verbatim).compact
      end
    end
  end

  module Types
    class MrkdwnBlock < TextBlock
      def type
        Composition::Mrkdwn::TYPE
      end

      def cast(value)
        case value
        when Composition::Mrkdwn
          value
        when Composition::PlainText
          Composition::Mrkdwn.new(text: value.text)
        when String, NilClass
          Composition::Mrkdwn.new(text: value)
        when Hash
          Composition::Mrkdwn.new(value.with_indifferent_access.slice(*Composition::Mrkdwn.attribute_names))
        else
          raise ArgumentError, "Cannot cast `#{value.inspect}' to BlockKit::Composition::Mrkdwn"
        end
      end
    end
  end
end
