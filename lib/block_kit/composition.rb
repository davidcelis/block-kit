# frozen_string_literal: true

module BlockKit
  module Composition
    autoload :ConfirmationDialog, "block_kit/composition/confirmation_dialog"
    autoload :ConversationFilter, "block_kit/composition/conversation_filter"
    autoload :DispatchActionConfig, "block_kit/composition/dispatch_action_config"
    autoload :InputParameter, "block_kit/composition/input_parameter"
    autoload :Mrkdwn, "block_kit/composition/mrkdwn"
    autoload :OptionGroup, "block_kit/composition/option_group"
    autoload :Option, "block_kit/composition/option"
    autoload :OverflowOption, "block_kit/composition/overflow_option"
    autoload :PlainText, "block_kit/composition/plain_text"
    autoload :SlackFile, "block_kit/composition/slack_file"
    autoload :Text, "block_kit/composition/text"
    autoload :Trigger, "block_kit/composition/trigger"
    autoload :Workflow, "block_kit/composition/workflow"
  end
end
