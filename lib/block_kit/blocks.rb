# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module BlockKit
  class Blocks
    attr_reader :blocks

    delegate_missing_to :blocks

    def initialize(allow: Layout.all)
      @blocks = TypedArray.new(Types::Blocks.new(*allow))

      yield(self) if block_given?
    end

    def actions(elements: nil, block_id: nil)
      block = Layout::Actions.new(elements: elements, block_id: block_id)

      yield(block) if block_given?

      append(block)
    end

    def context(elements: nil, block_id: nil)
      block = Layout::Context.new(elements: elements, block_id: block_id)

      yield(block) if block_given?

      append(block)
    end

    def divider(block_id: nil)
      append(Layout::Divider.new(block_id: block_id))
    end

    def header(text:, emoji: nil, block_id: nil)
      append(Layout::Header.new(text: text, block_id: block_id, emoji: emoji))
    end

    def image(alt_text:, image_url: nil, slack_file: nil, title: nil, emoji: nil, block_id: nil)
      if (image_url.nil? && slack_file.nil?) || (image_url && slack_file)
        raise ArgumentError, "Must provide either image_url or slack_file, but not both."
      end

      append(Layout::Image.new(image_url: image_url, slack_file: slack_file, alt_text: alt_text, title: title, block_id: block_id, emoji: emoji))
    end

    def input(label: nil, hint: nil, element: nil, optional: nil, dispatch_action: nil, emoji: nil, block_id: nil)
      block = Layout::Input.new(
        label: label,
        hint: hint,
        element: element,
        optional: optional,
        dispatch_action: dispatch_action,
        emoji: emoji,
        block_id: block_id
      )

      yield(block) if block_given?

      append(block)
    end

    def markdown(text:, block_id: nil)
      append(Layout::Markdown.new(text: text, block_id: block_id))
    end

    def rich_text(elements: nil, block_id: nil)
      block = Layout::RichText.new(elements: elements, block_id: block_id)

      yield(block) if block_given?

      append(block)
    end

    def section(text: nil, fields: nil, accessory: nil, expand: nil, block_id: nil)
      block = Layout::Section.new(text: text, fields: fields, accessory: accessory, expand: expand, block_id: block_id)

      yield(block) if block_given?

      append(block)
    end

    def video(alt_text:, title:, thumbnail_url:, video_url:, author_name: nil, description: nil, provider_icon_url: nil, provider_name: nil, title_url: nil, emoji: nil, block_id: nil)
      block = Layout::Video.new(
        alt_text: alt_text,
        title: title,
        thumbnail_url: thumbnail_url,
        video_url: video_url,
        author_name: author_name,
        description: description,
        provider_icon_url: provider_icon_url,
        provider_name: provider_name,
        title_url: title_url,
        emoji: emoji,
        block_id: block_id
      )

      append(block)
    end

    # Overridden to return `self`, allowing chaining.
    def append(block)
      @blocks << block

      self
    end

    def as_json(*)
      @blocks.map(&:as_json)
    end
  end
end
