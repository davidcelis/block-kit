# frozen_string_literal: true

module BlockKit
  module Composition
    autoload :ConversationFilter, "block_kit/composition/conversation_filter"
    autoload :Dialog, "block_kit/composition/dialog"
    autoload :DispatchActionConfiguration, "block_kit/composition/dispatch_action_configuration"
    autoload :Mrkdwn, "block_kit/composition/mrkdwn"
    autoload :Option, "block_kit/composition/option"
    autoload :OptionGroup, "block_kit/composition/option_group"
    autoload :OverflowOption, "block_kit/composition/overflow_option"
    autoload :PlainText, "block_kit/composition/plain_text"
    autoload :Text, "block_kit/composition/text"
  end
end
