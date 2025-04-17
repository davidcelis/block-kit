# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Message < BlockKit::Base
      self.type = :message

      attribute :text, :string
      attribute :blocks, Types::Array.of(Types::Blocks.new(*Layout.all))
      attribute :thread_ts, :string
      attribute :mrkdwn, :boolean

      validates :text, presence: true
      validates :blocks, length: {maximum: 50, message: "is too long (maximum is %{count} blocks)"}, "block_kit/validators/associated": true
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

      def initialize(attributes = {})
        attributes = attributes.with_indifferent_access
        attributes[:blocks] ||= []

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
        super().except(:type).merge(
          text: text,
          blocks: blocks&.map(&:as_json),
          thread_ts: thread_ts,
          mrkdwn: mrkdwn
        ).compact
      end
    end
  end
end
