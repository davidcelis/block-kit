# frozen_string_literal: true

module BlockKit
  module Layout
    class File < Base
      self.type = :file

      MAX_EXTERNAL_ID_LENGTH = 255

      attribute :external_id, :string
      validates :external_id, presence: true, length: {maximum: MAX_EXTERNAL_ID_LENGTH}
      fixes :external_id, truncate: {maximum: MAX_EXTERNAL_ID_LENGTH, dangerous: true}

      def as_json(*)
        super.merge(external_id: external_id, source: "remote").compact
      end
    end
  end
end
