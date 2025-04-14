# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiExternalSelect < MultiSelect
      self.type = :multi_external_select

      include Concerns::External

      attribute :initial_options, Types::Array.of(Composition::Option)
      validates :initial_options, "block_kit/validators/associated": true, allow_nil: true

      def initial_option(text:, value:, description: nil, emoji: nil)
        self.initial_options ||= []
        initial_options << Composition::Option.new(text: text, value: value, description: description, iniitial: true, emoji: emoji)
        self
      end

      def as_json(*)
        super.merge(initial_options: initial_options&.map(&:as_json)).compact
      end
    end
  end
end
