# frozen_string_literal: true

module BlockKit
  module Composition
    autoload :ConfirmationDialog, "block_kit/composition/confirmation_dialog"
    autoload :ConversationFilter, "block_kit/composition/conversation_filter"
    autoload :DispatchActionConfiguration, "block_kit/composition/dispatch_action_configuration"
    autoload :InputParameter, "block_kit/composition/input_parameter"
    autoload :Mrkdwn, "block_kit/composition/mrkdwn"
    autoload :Option, "block_kit/composition/option"
    autoload :OptionGroup, "block_kit/composition/option_group"
    autoload :OverflowOption, "block_kit/composition/overflow_option"
    autoload :PlainText, "block_kit/composition/plain_text"
    autoload :Text, "block_kit/composition/text"
    autoload :Trigger, "block_kit/composition/trigger"
    autoload :Workflow, "block_kit/composition/workflow"
  end
end
