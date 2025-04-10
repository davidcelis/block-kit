# frozen_string_literal: true

module BlockKit
  module Elements
    class StaticSelect < Select
      self.type = :static_select

      include Concerns::HasOptions.new(limit: 100, select: :single, groups: 100)
    end
  end
end
