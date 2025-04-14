# frozen_string_literal: true

module BlockKit
  module Concerns
    autoload :Confirmable, "block_kit/concerns/confirmable"
    autoload :ConversationSelection, "block_kit/concerns/conversation_selection"
    autoload :Dispatchable, "block_kit/concerns/dispatchable"
    autoload :External, "block_kit/concerns/external"
    autoload :FocusableOnLoad, "block_kit/concerns/focusable_on_load"
    autoload :HasInitialOption, "block_kit/concerns/has_initial_option"
    autoload :HasInitialOptions, "block_kit/concerns/has_initial_options"
    autoload :HasOptions, "block_kit/concerns/has_options"
    autoload :HasOptionGroups, "block_kit/concerns/has_option_groups"
    autoload :HasPlaceholder, "block_kit/concerns/has_placeholder"
    autoload :HasRichTextElements, "block_kit/concerns/has_rich_text_elements"
    autoload :PlainTextEmojiAssignment, "block_kit/concerns/plain_text_emoji_assignment"
  end
end
