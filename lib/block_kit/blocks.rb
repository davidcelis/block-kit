# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module BlockKit
  class Blocks < Base
    attribute :blocks, Types::Array.of(Types::Blocks.new(*Layout.all)), default: []
    validates :blocks, "block_kit/validators/associated": true
    fixes :blocks, associated: true

    dsl_method :blocks, as: :actions, type: Layout::Actions
    dsl_method :blocks, as: :context, type: Layout::Context
    dsl_method :blocks, as: :divider, type: Layout::Divider, yields: false
    dsl_method :blocks, as: :file, type: Layout::File, required_fields: [:external_id], yields: false
    dsl_method :blocks, as: :header, type: Layout::Header, required_fields: [:text], yields: false
    dsl_method :blocks, as: :input, type: Layout::Input
    dsl_method :blocks, as: :markdown, type: Layout::Markdown, required_fields: [:text], yields: false
    dsl_method :blocks, as: :rich_text, type: Layout::RichText
    dsl_method :blocks, as: :section, type: Layout::Section
    dsl_method :blocks, as: :video, type: Layout::Video, required_fields: [:alt_text, :title, :thumbnail_url, :video_url], yields: false

    delegate_missing_to :blocks

    def initialize(attributes = {})
      attributes = {blocks: attributes} if attributes.is_a?(Array)

      super
    end

    def image(alt_text:, image_url: nil, slack_file: nil, title: nil, emoji: nil, block_id: nil)
      if (image_url.nil? && slack_file.nil?) || (image_url && slack_file)
        raise ArgumentError, "Must provide either image_url or slack_file, but not both."
      end

      append(Layout::Image.new(image_url: image_url, slack_file: slack_file, alt_text: alt_text, title: title, block_id: block_id, emoji: emoji))
    end

    # Overridden to return `self`, allowing chaining.
    def append(block)
      blocks << block

      self
    end

    def as_json(*)
      blocks&.map(&:as_json)
    end
  end
end
