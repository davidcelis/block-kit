# frozen_string_literal: true

module BlockKit
  module Fixers
    autoload :Base, "block_kit/fixers/base"

    autoload :Associated, "block_kit/fixers/associated"
    autoload :NullValue, "block_kit/fixers/null_value"
    autoload :Truncate, "block_kit/fixers/truncate"
  end
end
