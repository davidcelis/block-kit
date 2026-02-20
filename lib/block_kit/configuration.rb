module BlockKit
  class Configuration
    # Controls whether or not calling `valid?` or `validate` on a block or surface
    # will automatically apply any fixes that would make the block or surface valid.
    attr_accessor :autofix_on_validation

    # Controls whether or not calling `as_json` on a block or surface will automatically
    # apply any fixes that would make the block or surface valid.
    attr_accessor :autofix_on_render

    # Controls whether or not autofixes that may change the behavior of your view should
    # be called. This is useful if you would rather post messages or publish views at the
    # cost of behavioral quirks or changes rather than suffer from `invalid_blocks` errors.
    #
    # If you'd prefer to run dangerous autofixers on demand, you can do this by
    # calling `fix_validation_errors(dangerous: true)` on your blocks or surfaces.
    attr_accessor :autofix_dangerously

    def initialize
      @autofix_on_validation = false
      @autofix_on_render = false
      @autofix_dangerously = false
    end
  end
end
