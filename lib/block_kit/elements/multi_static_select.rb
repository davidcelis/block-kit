# frozen_string_literal: true

module BlockKit
  module Elements
    class MultiStaticSelect < MultiSelect
      self.type = :multi_static_select

      include Concerns::HasOptionGroups.new(limit: 100, options_limit: 100)
      include Concerns::HasInitialOptions
    end
  end
end
