# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiStaticSelect < MultiSelect
      self.type = :multi_static_select

      include Concerns::HasOptions.new(limit: 100, select: :multi, groups: 100)
    end
  end
end
