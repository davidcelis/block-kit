# frozen_string_literal: true

require "active_support/core_ext/object/inclusion" # Necessary for `max_files.in?(1..10)`

module BlockKit
  module Elements
    class FileInput < Base
      self.type = :file_input

      attribute :filetypes, Types::Array.of(:string)
      attribute :max_files, :integer

      validates :filetypes, presence: true, allow_nil: true
      validates :max_files, presence: true, numericality: {in: 1..10, only_integer: true}, allow_nil: true

      def as_json(*)
        super.merge(
          filetypes: filetypes,
          max_files: max_files
        ).compact
      end
    end
  end
end
