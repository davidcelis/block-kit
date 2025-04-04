# frozen_string_literal: true

module BlockKit
  module Composition
    class OverflowOption < Option
      attribute :url, :string

      validates :url, length: {maximum: 3000, allow_nil: true}

      def as_json(*)
        super.merge(url: url).compact
      end
    end
  end
end
