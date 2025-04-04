# frozen_string_literal: true

module BlockKit
  module Composition
    autoload :Text, "block_kit/composition/text"
    autoload :PlainText, "block_kit/composition/plain_text"
    autoload :Mrkdwn, "block_kit/composition/mrkdwn"

    autoload :Dialog, "block_kit/composition/dialog"
  end
end
