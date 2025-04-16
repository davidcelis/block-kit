# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Base < BlockKit::Base
      self.type = :surface

      SUPPORTED_BLOCKS = [
        Layout::Actions,
        Layout::Context,
        Layout::Divider,
        Layout::Header,
        Layout::Image,
        Layout::Input,
        Layout::RichText,
        Layout::Section,
        Layout::Video
      ]

      attribute :blocks, Types::Array.of(Types::Blocks.new(*SUPPORTED_BLOCKS))
      attribute :private_metadata, :string
      attribute :callback_id, :string
      attribute :external_id, :string

      validates :blocks, presence: true, length: {maximum: 100, message: "is too long (maximum is %{count} blocks)"}, "block_kit/validators/associated": true
      fixes :blocks, associated: true

      validates :private_metadata, length: {maximum: 3000}, allow_nil: true
      validates :callback_id, length: {maximum: 255}, allow_nil: true
      validates :external_id, length: {maximum: 255}, allow_nil: true
      validate :only_one_element_focuses_on_load
      fix :unset_focus_on_load_on_all_elements

      dsl_method :blocks, as: :actions, type: Layout::Actions
      dsl_method :blocks, as: :context, type: Layout::Context
      dsl_method :blocks, as: :divider, type: Layout::Divider, yields: false
      dsl_method :blocks, as: :header, type: Layout::Header, required_fields: [:text], yields: false
      dsl_method :blocks, as: :input, type: Layout::Input
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
        super.merge(
          blocks: blocks&.map(&:as_json),
          private_metadata: private_metadata,
          callback_id: callback_id,
          external_id: external_id
        ).compact
      end

      private

      # Crawls through deeply nested blocks, looking for blocks that impelement the
      # BlockKit::Concerns::FocusableOnLoad concern, and ensures that only one of them
      # has `focus_on_load` set to true.
      def only_one_element_focuses_on_load
        focusable_blocks = blocks_that_focus_on_load

        if focusable_blocks.size > 1
          errors.add(:blocks, "can't have more than one element with focus_on_load set to true")

          focusable_blocks.each do |path, element|
            errors.add(path, "is invalid: can't set focus_on_load when other elements have set focus_on_load")
          end
        end
      end

      def blocks_that_focus_on_load
        blocks_by_path = {}

        blocks.each_with_index do |block, i|
          case block
          when Layout::Actions
            block.elements.each_with_index do |element, ei|
              if element.respond_to?(:focus_on_load) && element.focus_on_load
                blocks_by_path["blocks[#{i}].elements[#{ei}]"] = element
              end
            end
          when Layout::Input
            blocks_by_path["blocks[#{i}].element"] = block.element if block.element.respond_to?(:focus_on_load) && block.element.focus_on_load
          when Layout::Section
            blocks_by_path["blocks[#{i}].accessory"] = block.accessory if block.accessory.respond_to?(:focus_on_load) && block.accessory.focus_on_load
          end
        end

        blocks_by_path
      end

      def unset_focus_on_load_on_all_elements
        blocks_that_focus_on_load.values.each do |element|
          element.focus_on_load = false if element.respond_to?(:focus_on_load)
        end
      end
    end
  end
end
