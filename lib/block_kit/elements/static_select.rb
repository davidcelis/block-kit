# frozen_string_literal: true

module BlockKit
  module Elements
    class StaticSelect < Select
      self.type = :static_select

      include Concerns::HasOptionGroups.new(limit: 100, options_limit: 100)
      include Concerns::HasInitialOption
    end
  end
end
