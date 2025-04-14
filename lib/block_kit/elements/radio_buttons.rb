# frozen_string_literal: true

module BlockKit
  module Elements
    class RadioButtons < Base
      self.type = :radio_buttons

      include Concerns::Confirmable
      include Concerns::HasOptions.new(limit: 10)
      include Concerns::HasInitialOption
      include Concerns::FocusableOnLoad
    end
  end
end
