# frozen_string_literal: true

module BlockKit
  module Concerns
    autoload :Confirmable, "block_kit/concerns/confirmable"
    autoload :Dispatchable, "block_kit/concerns/dispatchable"
    autoload :FocusableOnLoad, "block_kit/concerns/focusable_on_load"
    autoload :HasOptions, "block_kit/concerns/has_options"
    autoload :HasPlaceholder, "block_kit/concerns/has_placeholder"
  end
end
