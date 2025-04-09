# frozen_string_literal: true

module BlockKit
  module Composition
    class InputParameter < Block
      self.type = :input_parameter

      attribute :name, :string
      attribute :value, :string

      validates :name, presence: true
      validates :value, presence: true

      def as_json(*)
        {name: name, value: value}.compact
      end
    end
  end
end
