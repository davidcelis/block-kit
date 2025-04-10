# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiSelect < Select
      attribute :max_selected_items, :integer

      validates :max_selected_items, presence: true, numericality: {only_integer: true, greater_than: 0}, allow_nil: true

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and cannot be instantiated." if instance_of?(MultiSelect)

        super
      end

      def as_json(*)
        super.merge(max_selected_items: max_selected_items).compact
      end
    end
  end
end
