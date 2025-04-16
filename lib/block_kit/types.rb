# frozen_string_literal: true

module BlockKit
  module Types
    autoload :Generic, "block_kit/types/generic"
    autoload :Blocks, "block_kit/types/blocks"

    autoload :Array, "block_kit/types/array"
    autoload :Mrkdwn, "block_kit/types/text"
    autoload :NumberInput, "block_kit/types/number_input"
    autoload :Option, "block_kit/types/option"
    autoload :OverflowOption, "block_kit/types/option"
    autoload :PlainText, "block_kit/types/text"
    autoload :Set, "block_kit/types/set"
    autoload :Text, "block_kit/types/text"
  end
end
