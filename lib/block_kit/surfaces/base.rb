# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Base < BlockKit::Base
      self.type = :surface

      MAX_BLOCKS = 100
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

      attribute :blocks, Types::Array.of(Types::Blocks.new(*SUPPORTED_BLOCKS)), default: []
      attribute :private_metadata, :string
      attribute :callback_id, :string
      attribute :external_id, :string

      validates :blocks, presence: true, length: {maximum: MAX_BLOCKS, message: "is too long (maximum is %{count} blocks)"}, "block_kit/validators/associated": true
      validate :no_unsupported_elements
      fix :remove_unsupported_elements, dangerous: true
      fixes :blocks, truncate: {maximum: MAX_BLOCKS, dangerous: true}, associated: true

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

      def self.inherited(subclass)
        subclass.attribute_fixers = attribute_fixers.deep_dup
      end

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(Base)

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

      def no_unsupported_elements
        unsupported_elements = unsupported_elements_by_path
        return if unsupported_elements.empty?

        errors.add(:blocks, "contains unsupported elements")

        unsupported_elements.each do |path, element|
          errors.add(path, "is invalid: #{element.class.type} is not a supported element for this surface")
        end
      end

      # Crawls through deeply nested blocks, looking for blocks that impelement the
      # BlockKit::Concerns::FocusableOnLoad concern, and ensures that only one of them
      # has `focus_on_load` set to true.
      def only_one_element_focuses_on_load
        focusable_blocks = focused_blocks_by_path

        if focusable_blocks.size > 1
          errors.add(:blocks, "can't have more than one element with focus_on_load set to true")

          focusable_blocks.each do |path, element|
            errors.add(path, "is invalid: can't set focus_on_load when other elements have set focus_on_load")
          end
        end
      end

      def unsupported_elements_by_path
        unsupported_elements = {}

        blocks.each_with_index do |block, index|
          # Context block elements are globally supported, so we don't need to check them.
          case block
          when Layout::Actions
            block.elements.each_with_index do |element, element_index|
              unless self.class::SUPPORTED_ELEMENTS.include?(element.class)
                unsupported_elements["blocks[#{index}].elements[#{element_index}]"] = element
              end
            end
          when Layout::Input
            if block.element.present? && !self.class::SUPPORTED_ELEMENTS.include?(block.element.class)
              unsupported_elements["blocks[#{index}].element"] = block.element
            end
          when Layout::Section
            if block.accessory.present? && !self.class::SUPPORTED_ELEMENTS.include?(block.accessory.class)
              unsupported_elements["blocks[#{index}].accessory"] = block.accessory
            end
          end
        end

        unsupported_elements
      end

      def focused_blocks_by_path
        focused_blocks = {}

        blocks.each_with_index do |block, i|
          case block
          when Layout::Actions
            block.elements.each_with_index do |element, ei|
              if element.respond_to?(:focus_on_load) && element.focus_on_load
                focused_blocks["blocks[#{i}].elements[#{ei}]"] = element
              end
            end
          when Layout::Input
            focused_blocks["blocks[#{i}].element"] = block.element if block.element.respond_to?(:focus_on_load) && block.element.focus_on_load
          when Layout::Section
            focused_blocks["blocks[#{i}].accessory"] = block.accessory if block.accessory.respond_to?(:focus_on_load) && block.accessory.focus_on_load
          end
        end

        focused_blocks
      end

      def remove_unsupported_elements
        blocks.each do |block|
          case block
          when Layout::Actions
            block.elements.delete_if { |element| !self.class::SUPPORTED_ELEMENTS.include?(element.class) }
          when Layout::Input
            block.element = nil unless self.class::SUPPORTED_ELEMENTS.include?(block.element.class)
          when Layout::Section
            block.accessory = nil unless self.class::SUPPORTED_ELEMENTS.include?(block.accessory.class)
          end
        end
      end

      def unset_focus_on_load_on_all_elements
        focused_blocks_by_path.values.each do |element|
          element.focus_on_load = false if element.respond_to?(:focus_on_load)
        end
      end
    end
  end
end
