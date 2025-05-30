# frozen_string_literal: true

module BlockKit
  module Layout
    autoload :Base, "block_kit/layout/base"

    autoload :Actions, "block_kit/layout/actions"
    autoload :Context, "block_kit/layout/context"
    autoload :Divider, "block_kit/layout/divider"
    autoload :File, "block_kit/layout/file"
    autoload :Header, "block_kit/layout/header"
    autoload :Image, "block_kit/layout/image"
    autoload :Input, "block_kit/layout/input"
    autoload :Markdown, "block_kit/layout/markdown"
    autoload :RichText, "block_kit/layout/rich_text"
    autoload :Section, "block_kit/layout/section"
    autoload :Video, "block_kit/layout/video"

    def self.all
      @all ||= [
        Actions,
        Context,
        Divider,
        File,
        Header,
        Image,
        Input,
        Markdown,
        RichText,
        Section,
        Video
      ].freeze
    end
  end
end
