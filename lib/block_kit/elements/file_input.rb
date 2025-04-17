# frozen_string_literal: true

require "active_support/core_ext/object/inclusion" # Necessary for `max_files.in?(1..10)`

module BlockKit
  module Elements
    class FileInput < Base
      self.type = :file_input

      VALID_MAX_FILES_RANGE = 1..10

      attribute :filetypes, Types::Set.of(:string)
      attribute :max_files, :integer

      validates :filetypes, presence: true, allow_nil: true
      validates :max_files, presence: true, numericality: {in: VALID_MAX_FILES_RANGE, only_integer: true}, allow_nil: true
      fix :clamp_max_files

      def as_json(*)
        super.merge(
          filetypes: filetypes&.to_a,
          max_files: max_files
        ).compact
      end

      private

      def clamp_max_files
        self.max_files = max_files&.clamp(VALID_MAX_FILES_RANGE)
      end
    end
  end
end
