# frozen_string_literal: true

module BlockKit
  module Concerns
    module HasRichTextElements
      extend ActiveSupport::Concern

      included do
        attribute :elements, Types::Array.of(Types::Blocks.new(*Layout::RichText::Elements.all))
        validates :elements, presence: true, "block_kit/validators/associated": true
      end

      def broadcast(range:)
        append(Layout::RichText::Elements::Broadcast.new(range: range))
      end

      def channel(channel_id:, styles: [])
        style = if styles.present?
          styles = Array(styles).map { |s| [s.to_s, true] }.to_h
          Layout::RichText::Elements::MentionStyle.new(**styles.slice(*Layout::RichText::Elements::MentionStyle.attribute_names))
        end

        append(Layout::RichText::Elements::Channel.new(channel_id: channel_id, style: style))
      end

      def color(value:)
        append(Layout::RichText::Elements::Color.new(value: value))
      end

      def date(timestamp:, format:, url: nil, fallback: nil)
        append(Layout::RichText::Elements::Date.new(timestamp: timestamp, format: format, url: url, fallback: fallback))
      end

      def emoji(name:, unicode: nil)
        append(Layout::RichText::Elements::Emoji.new(name: name, unicode: unicode))
      end

      def link(url:, text:, unsafe: nil, styles: nil)
        style = if styles.present?
          styles = Array(styles).map { |s| [s.to_s, true] }.to_h
          Layout::RichText::Elements::TextStyle.new(**styles.slice(*Layout::RichText::Elements::TextStyle.attribute_names))
        end

        append(Layout::RichText::Elements::Link.new(url: url, text: text, unsafe: unsafe, style: style))
      end

      def text(text:, styles: nil)
        style = if styles.present?
          styles = Array(styles).map { |s| [s.to_s, true] }.to_h
          Layout::RichText::Elements::TextStyle.new(**styles.slice(*Layout::RichText::Elements::TextStyle.attribute_names))
        end

        append(Layout::RichText::Elements::Text.new(text: text, style: style))
      end

      def usergroup(usergroup_id:, styles: [])
        style = if styles.present?
          styles = Array(styles).map { |s| [s.to_s, true] }.to_h
          Layout::RichText::Elements::MentionStyle.new(**styles.slice(*Layout::RichText::Elements::MentionStyle.attribute_names))
        end

        append(Layout::RichText::Elements::Usergroup.new(usergroup_id: usergroup_id, style: style))
      end
      alias_method :user_group, :usergroup

      def user(user_id:, styles: [])
        style = if styles.present?
          styles = Array(styles).map { |s| [s.to_s, true] }.to_h
          Layout::RichText::Elements::MentionStyle.new(**styles.slice(*Layout::RichText::Elements::MentionStyle.attribute_names))
        end

        append(Layout::RichText::Elements::User.new(user_id: user_id, style: style))
      end

      def append(element)
        elements << element

        self
      end

      def as_json(*)
        super.merge(
          elements: elements&.map(&:as_json)
        ).compact
      end
    end
  end
end
