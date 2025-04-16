# frozen_string_literal: true

module BlockKit
  module Layout
    class File < Base
      self.type = :file

      attribute :external_id, :string
      validates :external_id, presence: true, length: {maximum: 255}

      def as_json(*)
        super.merge(external_id: external_id, source: "remote").compact
      end
    end
  end
end
