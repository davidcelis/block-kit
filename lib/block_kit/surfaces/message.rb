# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Message < BlockKit::Base
      self.type = :message

      MAX_BLOCKS = 50
      SUPPORTED_ELEMENTS = [
        Elements::Button,
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
        Elements::DatetimePicker,
        Elements::ExternalSelect,
        Elements::Image,
        Elements::MultiChannelsSelect,
        Elements::MultiConversationsSelect,
        Elements::MultiExternalSelect,
        Elements::MultiStaticSelect,
        Elements::MultiUsersSelect,
        Elements::Overflow,
        Elements::PlainTextInput,
        Elements::RadioButtons,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::UsersSelect,
        Elements::WorkflowButton
      ].freeze

      attribute :text, :string
      attribute :blocks, Types::Array.of(Types::Blocks.new(*Layout.all))
      attribute :thread_ts, :string
      attribute :mrkdwn, :boolean

      validates :text, presence: true
      validates :blocks, length: {maximum: MAX_BLOCKS, message: "is too long (maximum is %{count} blocks)"}, "block_kit/validators/associated": true
      validate :no_unsupported_elements
      fix :remove_unsupported_elements, dangerous: true
      fixes :blocks, truncate: {maximum: MAX_BLOCKS, dangerous: true}, associated: true

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

      private

      def no_unsupported_elements
        unsupported_elements = unsupported_elements_by_path
        return if unsupported_elements.empty?

        errors.add(:blocks, "contains unsupported elements")

        unsupported_elements.each do |path, element|
          errors.add(path, "is invalid: #{element.class.type} is not a supported element for this surface")
        end
      end

      def unsupported_elements_by_path
        unsupported_elements = {}

        blocks.each_with_index do |block, index|
          # Context block elements are globally supported, so we don't need to check them.
          case block
          when Layout::Actions
            block.elements.each_with_index do |element, element_index|
              unless SUPPORTED_ELEMENTS.include?(element.class)
                unsupported_elements["blocks[#{index}].elements[#{element_index}]"] = element
              end
            end
          when Layout::Input
            if block.element.present? && !SUPPORTED_ELEMENTS.include?(block.element.class)
              unsupported_elements["blocks[#{index}].element"] = block.element
            end
          when Layout::Section
            if block.accessory.present? && !SUPPORTED_ELEMENTS.include?(block.accessory.class)
              unsupported_elements["blocks[#{index}].accessory"] = block.accessory
            end
          end
        end

        unsupported_elements
      end

      def remove_unsupported_elements
        blocks.each do |block|
          case block
          when Layout::Actions
            block.elements.delete_if { |element| !SUPPORTED_ELEMENTS.include?(element.class) }
          when Layout::Input
            block.element = nil unless SUPPORTED_ELEMENTS.include?(block.element.class)
          when Layout::Section
            block.accessory = nil unless SUPPORTED_ELEMENTS.include?(block.accessory.class)
          end
        end
      end
    end
  end
end
