# frozen_string_literal: true

module BlockKit
  module Layout
    module RichText::Elements
      autoload :Broadcast, "block_kit/layout/rich_text/elements/broadcast"
      autoload :Channel, "block_kit/layout/rich_text/elements/channel"
      autoload :Color, "block_kit/layout/rich_text/elements/color"
      autoload :Date, "block_kit/layout/rich_text/elements/date"
      autoload :Emoji, "block_kit/layout/rich_text/elements/emoji"
      autoload :Link, "block_kit/layout/rich_text/elements/link"
      autoload :Text, "block_kit/layout/rich_text/elements/text"
      autoload :User, "block_kit/layout/rich_text/elements/user"
      autoload :Usergroup, "block_kit/layout/rich_text/elements/usergroup"
      autoload :UserGroup, "block_kit/layout/rich_text/elements/usergroup"

      # Utility blocks
      autoload :MentionStyle, "block_kit/layout/rich_text/elements/mention_style"
      autoload :TextStyle, "block_kit/layout/rich_text/elements/text_style"

      def self.all
        @all ||= [
          Broadcast,
          Channel,
          Color,
          Date,
          Emoji,
          Link,
          Text,
          User,
          Usergroup
        ].freeze
      end
    end
  end
end
