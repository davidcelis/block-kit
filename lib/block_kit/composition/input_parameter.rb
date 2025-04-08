# frozen_string_literal: true

module BlockKit
  module Composition
    class InputParameter < Block
      attribute :name, :string
      attribute :value, :string

      self.required_attributes = [:name, :value]

      validates :name, presence: true
      validates :value, presence: true

      def as_json(*)
        {name: name, value: value}.compact
      end
    end
  end
end
