# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiSelect < Base
      include Concerns::Confirmable
      include Concerns::FocusableOnLoad

      attribute :max_selected_items, :integer
      attribute :placeholder, Types::PlainText.instance

      validates :max_selected_items, presence: true, numericality: {only_integer: true, greater_than: 0}, allow_nil: true
      validates :placeholder, presence: true, length: {maximum: 150}, allow_nil: true

      def initialize(attributes = {})
        raise NotImplementedError, "#{self} is an abstract class and cannot be instantiated." if instance_of?(MultiSelect)

        super
      end

      def as_json(*)
        super.merge(
          max_selected_items: max_selected_items,
          placeholder: placeholder&.as_json
        ).compact
      end
    end
  end
end
