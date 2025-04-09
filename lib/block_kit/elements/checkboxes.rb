# frozen_string_literal: true

module BlockKit
  module Elements
    class Checkboxes < Base
      self.type = :checkboxes

      include Concerns::Confirmable
      include Concerns::HasOptions.new(limit: 10, select: :multi)
      include Concerns::FocusableOnLoad
    end
  end
end
