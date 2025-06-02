# frozen_string_literal: true

require "active_model"

module BlockKit
  module Surfaces
    class Home < Base
      self.type = :home

      SUPPORTED_ELEMENTS = [
        Elements::Button,
        Elements::ChannelsSelect,
        Elements::Checkboxes,
        Elements::ConversationsSelect,
        Elements::DatePicker,
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
        Elements::RichTextInput,
        Elements::StaticSelect,
        Elements::TimePicker,
        Elements::UsersSelect
      ].freeze
    end
  end
end
