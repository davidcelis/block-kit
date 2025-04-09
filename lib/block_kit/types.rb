# frozen_string_literal: true

module BlockKit
  module Types
    autoload :Array, "block_kit/types/array"
    autoload :ConfirmationDialog, "block_kit/types/confirmation_dialog"
    autoload :DispatchActionConfiguration, "block_kit/types/dispatch_action_configuration"
    autoload :InputParameter, "block_kit/types/input_parameter"
    autoload :Mrkdwn, "block_kit/types/text"
    autoload :Option, "block_kit/types/option"
    autoload :PlainText, "block_kit/types/text"
    autoload :Text, "block_kit/types/text"
    autoload :Trigger, "block_kit/types/trigger"
  end
end
