# frozen_string_literal: true

module BlockKit
  module Elements
    autoload :Base, "block_kit/elements/base"

    autoload :Button, "block_kit/elements/button"
    autoload :Checkboxes, "block_kit/elements/checkboxes"
    autoload :DatePicker, "block_kit/elements/date_picker"
    autoload :DatetimePicker, "block_kit/elements/datetime_picker"
    autoload :EmailTextInput, "block_kit/elements/email_text_input"
    autoload :FileInput, "block_kit/elements/file_input"
    autoload :Image, "block_kit/elements/image"
    autoload :MultiChannelsSelect, "block_kit/elements/multi_channels_select"
    autoload :MultiConversationsSelect, "block_kit/elements/multi_conversations_select"
    autoload :MultiExternalSelect, "block_kit/elements/multi_external_select"
    autoload :MultiSelect, "block_kit/elements/multi_select"
    autoload :MultiStaticSelect, "block_kit/elements/multi_static_select"
    autoload :MultiUsersSelect, "block_kit/elements/multi_users_select"
  end
end
