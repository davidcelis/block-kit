# frozen_string_literal: true

module BlockKit
  module Elements
    class Checkboxes < Base
      self.type = :checkboxes

      include Concerns::Confirmable
      include Concerns::HasOptions.new(limit: 10)
      include Concerns::HasInitialOptions
      include Concerns::FocusableOnLoad
    end
  end
end
