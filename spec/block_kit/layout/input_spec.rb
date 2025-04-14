# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Input, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      label: "Name",
      element: BlockKit::Elements::PlainTextInput.new(placeholder: "Enter your name")
    }
  end

  describe "#channels_select" do
    let(:args) { {} }
    subject { block.channels_select(**args) }

    it "adds a channels select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::ChannelsSelect))
      expect(subject).to eq(block)
    end

    it "yields the channels select" do
      expect { |b| block.channels_select(**args, &b) }.to yield_with_args(BlockKit::Elements::ChannelsSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select a channel",
          initial_channel: "C12345678",
          response_url_enabled: true,
          focus_on_load: false,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a channels select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::ChannelsSelect))
        expect(block.element.placeholder.text).to eq("Select a channel")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_channel).to eq("C12345678")
        expect(block.element.response_url_enabled).to be true
        expect(block.element.focus_on_load).to be false
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#checkboxes" do
    let(:args) { {} }
    subject { block.checkboxes(**args) }

    it "adds a checkboxes as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::Checkboxes))
      expect(subject).to eq(block)
    end

    it "yields the checkboxes" do
      expect { |b| block.checkboxes(**args, &b) }.to yield_with_args(BlockKit::Elements::Checkboxes)
    end

    context "with optional args" do
      let(:args) do
        {
          options: [
            BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
            BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
          ],
          focus_on_load: true,
          confirm: {title: "Confirm"},
          action_id: "action_id"
        }
      end

      it "creates a checkboxes with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::Checkboxes))
        expect(block.element.options.size).to eq(2)
        expect(block.element.options.first.text.text).to eq("Option 1")
        expect(block.element.options.first.value).to eq("option_1")
        expect(block.element.options.last.text.text).to eq("Option 2")
        expect(block.element.options.last.value).to eq("option_2")
        expect(block.element.options.last).to be_initial
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#conversations_select" do
    let(:args) { {} }
    subject { block.conversations_select(**args) }

    it "adds a conversations select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::ConversationsSelect))
      expect(subject).to eq(block)
    end

    it "yields the conversations select" do
      expect { |b| block.conversations_select(**args, &b) }.to yield_with_args(BlockKit::Elements::ConversationsSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select a conversation",
          initial_conversation: "C12345678",
          default_to_current_conversation: true,
          response_url_enabled: false,
          focus_on_load: true,
          confirm: {title: "Confirm"},
          filter: {include: [:im, :public]},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a conversations select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::ConversationsSelect))
        expect(block.element.placeholder.text).to eq("Select a conversation")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_conversation).to eq("C12345678")
        expect(block.element.default_to_current_conversation).to be true
        expect(block.element.response_url_enabled).to be false
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.filter.include).to eq(["im", "public"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#datepicker" do
    let(:args) { {} }
    subject { block.datepicker(**args) }

    it "adds a datepicker as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::DatePicker))
      expect(subject).to eq(block)
    end

    it "yields the datepicker" do
      expect { |b| block.datepicker(**args, &b) }.to yield_with_args(BlockKit::Elements::DatePicker)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select a date",
          initial_date: "2025-04-13",
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a datepicker with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::DatePicker))
        expect(block.element.placeholder.text).to eq("Select a date")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_date).to eq(Date.parse("2025-04-13"))
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#datetimepicker" do
    let(:args) { {} }
    subject { block.datetimepicker(**args) }

    it "adds a datetimepicker as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::DatetimePicker))
      expect(subject).to eq(block)
    end

    it "yields the datetimepicker" do
      expect { |b| block.datetimepicker(**args, &b) }.to yield_with_args(BlockKit::Elements::DatetimePicker)
    end

    context "with optional args" do
      let(:args) do
        {
          initial_date_time: "2025-04-13T16:01:48Z",
          focus_on_load: true,
          confirm: {title: "Confirm"},
          action_id: "action_id"
        }
      end

      it "creates a datetimepicker with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::DatetimePicker))
        expect(block.element.initial_date_time).to eq(Time.iso8601("2025-04-13T16:01:48Z"))
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#email_text_input" do
    let(:args) { {} }
    subject { block.email_text_input(**args) }

    it "adds an email text input as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::EmailTextInput))
      expect(subject).to eq(block)
    end

    it "yields the email text input" do
      expect { |b| block.email_text_input(**args, &b) }.to yield_with_args(BlockKit::Elements::EmailTextInput)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Enter your email",
          initial_value: "hello@example.com",
          focus_on_load: true,
          dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates an email text input with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::EmailTextInput))
        expect(block.element.placeholder.text).to eq("Enter your email")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.focus_on_load).to be true
        expect(block.element.dispatch_action_config.trigger_actions_on).to eq(["on_enter_pressed"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#external_select" do
    let(:args) { {} }
    subject { block.external_select(**args) }

    it "adds an external select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::ExternalSelect))
      expect(subject).to eq(block)
    end

    it "yields the external select" do
      expect { |b| block.external_select(**args, &b) }.to yield_with_args(BlockKit::Elements::ExternalSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select an option",
          initial_option: {text: "Option 1", value: "option_1"},
          min_query_length: 3,
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates an external select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::ExternalSelect))
        expect(block.element.placeholder.text).to eq("Select an option")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_option.text.text).to eq("Option 1")
        expect(block.element.initial_option.value).to eq("option_1")
        expect(block.element.min_query_length).to eq(3)
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#file_input" do
    let(:args) { {} }
    subject { block.file_input(**args) }

    it "adds a file input as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::FileInput))
      expect(subject).to eq(block)
    end

    it "yields the file input" do
      expect { |b| block.file_input(**args, &b) }.to yield_with_args(BlockKit::Elements::FileInput)
    end

    context "with optional args" do
      let(:args) do
        {
          filetypes: ["png", "jpg"],
          max_files: 3,
          action_id: "action_id"
        }
      end

      it "creates a file input with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::FileInput))
        expect(block.element.filetypes).to eq(["png", "jpg"])
        expect(block.element.max_files).to eq(3)
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_channels_select" do
    let(:args) { {} }
    subject { block.multi_channels_select(**args) }

    it "adds a channels select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiChannelsSelect))
      expect(subject).to eq(block)
    end

    it "yields the channels select" do
      expect { |b| block.multi_channels_select(**args, &b) }.to yield_with_args(BlockKit::Elements::MultiChannelsSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select some channels",
          initial_channels: ["C12345678", "C23456789"],
          max_selected_items: 3,
          focus_on_load: false,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a channels select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiChannelsSelect))
        expect(block.element.placeholder.text).to eq("Select some channels")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_channels).to eq(["C12345678", "C23456789"])
        expect(block.element.max_selected_items).to eq(3)
        expect(block.element.focus_on_load).to be false
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_conversations_select" do
    let(:args) { {} }
    subject { block.multi_conversations_select(**args) }

    it "adds a conversations select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiConversationsSelect))
      expect(subject).to eq(block)
    end

    it "yields the conversations select" do
      expect { |b| block.multi_conversations_select(**args, &b) }.to yield_with_args(BlockKit::Elements::MultiConversationsSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select some conversations",
          initial_conversations: ["C12345678", "C23456789"],
          max_selected_items: 3,
          default_to_current_conversation: true,
          focus_on_load: true,
          confirm: {title: "Confirm"},
          filter: {include: [:im, :public]},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a conversations select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiConversationsSelect))
        expect(block.element.placeholder.text).to eq("Select some conversations")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_conversations).to eq(["C12345678", "C23456789"])
        expect(block.element.max_selected_items).to eq(3)
        expect(block.element.default_to_current_conversation).to be true
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.filter.include).to eq(["im", "public"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_external_select" do
    let(:args) { {} }
    subject { block.multi_external_select(**args) }

    it "adds an external select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiExternalSelect))
      expect(subject).to eq(block)
    end

    it "yields the external select" do
      expect { |b| block.multi_external_select(**args, &b) }.to yield_with_args(BlockKit::Elements::MultiExternalSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select some options",
          initial_options: [{text: "Option 1", value: "option_1"}],
          min_query_length: 1,
          max_selected_items: 3,
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates an external select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiExternalSelect))
        expect(block.element.placeholder.text).to eq("Select some options")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.min_query_length).to eq(1)
        expect(block.element.max_selected_items).to eq(3)
        expect(block.element.initial_options.size).to eq(1)
        expect(block.element.initial_options.first.text.text).to eq("Option 1")
        expect(block.element.initial_options.first.value).to eq("option_1")
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_static_select" do
    let(:args) { {} }
    subject { block.multi_static_select(**args) }

    it "adds a static select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiStaticSelect))
    end

    it "yields the static select" do
      expect { |b| block.multi_static_select(**args, &b) }.to yield_with_args(BlockKit::Elements::MultiStaticSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select some options",
          options: [
            {text: "Option 1", value: "option_1"},
            {text: "Option 2", value: "option_2", initial: true}
          ],
          max_selected_items: 3,
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a static select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiStaticSelect))
        expect(block.element.placeholder.text).to eq("Select some options")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.max_selected_items).to eq(3)
        expect(block.element.options.size).to eq(2)
        expect(block.element.options.first.text.text).to eq("Option 1")
        expect(block.element.options.first.value).to eq("option_1")
        expect(block.element.options.last.text.text).to eq("Option 2")
        expect(block.element.options.last.value).to eq("option_2")
        expect(block.element.options.last).to be_initial
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end

    context "with option groups" do
      let(:args) do
        {
          option_groups: [
            {label: "Group 1", options: [{text: "Option 1", value: "option_1"}]},
            {label: "Group 2", options: [{text: "Option 2", value: "option_2", initial: true}]}
          ]

        }
      end

      it "creates a static select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiStaticSelect))
        expect(block.element.option_groups.size).to eq(2)
        expect(block.element.option_groups.first.label.text).to eq("Group 1")
        expect(block.element.option_groups.first.options.size).to eq(1)
        expect(block.element.option_groups.first.options.first.text.text).to eq("Option 1")
        expect(block.element.option_groups.first.options.first.value).to eq("option_1")
        expect(block.element.option_groups.last.label.text).to eq("Group 2")
        expect(block.element.option_groups.last.options.size).to eq(1)
        expect(block.element.option_groups.last.options.first.text.text).to eq("Option 2")
        expect(block.element.option_groups.last.options.first.value).to eq("option_2")
        expect(block.element.option_groups.last.options.first).to be_initial
      end
    end

    context "with option groups and options" do
      let(:args) do
        {
          options: [],
          option_groups: []
        }
      end

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Can't provide both options and option_groups")
        expect(block.element).not_to be_a(BlockKit::Elements::MultiStaticSelect)
      end
    end
  end

  describe "#multi_users_select" do
    let(:args) { {} }
    subject { block.multi_users_select(**args) }

    it "adds a users select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiUsersSelect))
      expect(subject).to eq(block)
    end

    it "yields the users select" do
      expect { |b| block.multi_users_select(**args, &b) }.to yield_with_args(BlockKit::Elements::MultiUsersSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select some users",
          initial_users: ["U12345678", "U23456789"],
          max_selected_items: 3,
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a users select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::MultiUsersSelect))
        expect(block.element.placeholder.text).to eq("Select some users")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_users).to eq(["U12345678", "U23456789"])
        expect(block.element.max_selected_items).to eq(3)
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#number_input" do
    let(:args) { {} }
    subject { block.number_input(**args) }

    it "adds a number input as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::NumberInput))
      expect(subject).to eq(block)
    end

    it "yields the number input" do
      expect { |b| block.number_input(**args, &b) }.to yield_with_args(BlockKit::Elements::NumberInput)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Enter a number",
          is_decimal_allowed: false,
          initial_value: 5,
          min_value: 1,
          max_value: 10,
          focus_on_load: true,
          dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a number input with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::NumberInput))
        expect(block.element.placeholder.text).to eq("Enter a number")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.is_decimal_allowed).to be false
        expect(block.element.initial_value).to eq(5)
        expect(block.element.min_value).to eq(1)
        expect(block.element.max_value).to eq(10)
        expect(block.element.focus_on_load).to be true
        expect(block.element.dispatch_action_config.trigger_actions_on).to eq(["on_enter_pressed"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#plain_text_input" do
    let(:args) { {} }
    subject { block.plain_text_input(**args) }

    it "adds a plain text input as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::PlainTextInput))
      expect(subject).to eq(block)
    end

    it "yields the plain text input" do
      expect { |b| block.plain_text_input(**args, &b) }.to yield_with_args(BlockKit::Elements::PlainTextInput)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Enter your name",
          initial_value: "John Doe",
          min_length: 1,
          max_length: 50,
          multiline: false,
          focus_on_load: true,
          dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a plain text input with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::PlainTextInput))
        expect(block.element.placeholder.text).to eq("Enter your name")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_value).to eq("John Doe")
        expect(block.element.min_length).to eq(1)
        expect(block.element.max_length).to eq(50)
        expect(block.element.multiline).to be false
        expect(block.element.focus_on_load).to be true
        expect(block.element.dispatch_action_config.trigger_actions_on).to eq(["on_enter_pressed"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#radio_buttons" do
    let(:args) { {} }
    subject { block.radio_buttons(**args) }

    it "adds a radio buttons as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::RadioButtons))
      expect(subject).to eq(block)
    end

    it "yields the radio buttons" do
      expect { |b| block.radio_buttons(**args, &b) }.to yield_with_args(BlockKit::Elements::RadioButtons)
    end

    context "with optional args" do
      let(:args) do
        {
          options: [
            BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
            BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
          ],
          focus_on_load: true,
          confirm: {title: "Confirm"},
          action_id: "action_id"
        }
      end

      it "creates a radio buttons with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::RadioButtons))
        expect(block.element.options.size).to eq(2)
        expect(block.element.options.first.text.text).to eq("Option 1")
        expect(block.element.options.first.value).to eq("option_1")
        expect(block.element.options.last.text.text).to eq("Option 2")
        expect(block.element.options.last.value).to eq("option_2")
        expect(block.element.options.last).to be_initial
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#rich_text_input" do
    let(:args) { {} }
    subject { block.rich_text_input(**args) }

    it "adds a rich text input as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::RichTextInput))
      expect(subject).to eq(block)
    end

    it "yields the rich text input" do
      expect { |b| block.rich_text_input(**args, &b) }.to yield_with_args(BlockKit::Elements::RichTextInput)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Type something",
          initial_value: BlockKit::Layout::RichText.new,
          focus_on_load: true,
          dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
          action_id: "action_id"
        }
      end

      it "creates a rich text input with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::RichTextInput))
        expect(block.element.placeholder.text).to eq("Type something")
        expect(block.element.initial_value).to eq(args[:initial_value])
        expect(block.element.focus_on_load).to be true
        expect(block.element.dispatch_action_config.trigger_actions_on).to eq(["on_enter_pressed"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#static_select" do
    let(:args) { {} }
    subject { block.static_select(**args) }

    it "adds a static select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::StaticSelect))
      expect(subject).to eq(block)
    end

    it "yields the static select" do
      expect { |b| block.static_select(**args, &b) }.to yield_with_args(BlockKit::Elements::StaticSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select an option",
          options: [
            BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
            BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
          ],
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a static select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::StaticSelect))
        expect(block.element.placeholder.text).to eq("Select an option")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.options.size).to eq(2)
        expect(block.element.options.first.text.text).to eq("Option 1")
        expect(block.element.options.first.value).to eq("option_1")
        expect(block.element.options.last.text.text).to eq("Option 2")
        expect(block.element.options.last.value).to eq("option_2")
        expect(block.element.options.last).to be_initial
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end

    context "with option groups" do
      let(:args) do
        {
          option_groups: [
            {label: "Group 1", options: [{text: "Option 1", value: "option_1"}]},
            {label: "Group 2", options: [{text: "Option 2", value: "option_2", initial: true}]}
          ]
        }
      end

      it "creates a static select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::StaticSelect))
        expect(block.element.option_groups.size).to eq(2)
        expect(block.element.option_groups.first.label.text).to eq("Group 1")
        expect(block.element.option_groups.first.options.size).to eq(1)
        expect(block.element.option_groups.first.options.first.text.text).to eq("Option 1")
        expect(block.element.option_groups.first.options.first.value).to eq("option_1")
        expect(block.element.option_groups.last.label.text).to eq("Group 2")
        expect(block.element.option_groups.last.options.size).to eq(1)
        expect(block.element.option_groups.last.options.first.text.text).to eq("Option 2")
        expect(block.element.option_groups.last.options.first.value).to eq("option_2")
        expect(block.element.option_groups.last.options.first).to be_initial
      end
    end

    context "with option groups and options" do
      let(:args) do
        {
          options: [],
          option_groups: []
        }
      end

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Can't provide both options and option_groups")
        expect(block.element).not_to be_a(BlockKit::Elements::StaticSelect)
      end
    end
  end

  describe "#timepicker" do
    let(:args) { {} }
    subject { block.timepicker(**args) }

    it "adds a timepicker as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::TimePicker))
      expect(block.element).to be_a(BlockKit::Elements::TimePicker)
    end

    it "yields the timepicker" do
      expect { |b| block.timepicker(**args, &b) }.to yield_with_args(BlockKit::Elements::TimePicker)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select a time",
          initial_time: "12:00",
          timezone: "America/Los_Angeles",
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a timepicker with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::TimePicker))
        expect(block.element.placeholder.text).to eq("Select a time")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_time).to eq(Time.parse("12:00 UTC").change(year: 2000, day: 1, month: 1))
        expect(block.element.timezone).to eq(ActiveSupport::TimeZone["America/Los_Angeles"])
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#users_select" do
    let(:args) { {} }
    subject { block.users_select(**args) }

    it "adds a users select as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::UsersSelect))
      expect(block.element).to be_a(BlockKit::Elements::UsersSelect)
    end

    it "yields the users select" do
      expect { |b| block.users_select(**args, &b) }.to yield_with_args(BlockKit::Elements::UsersSelect)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Select a user",
          initial_user: "U12345678",
          focus_on_load: true,
          confirm: {title: "Confirm"},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a users select with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::UsersSelect))
        expect(block.element.placeholder.text).to eq("Select a user")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_user).to eq("U12345678")
        expect(block.element.focus_on_load).to be true
        expect(block.element.confirm.title.text).to eq("Confirm")
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#url_text_input" do
    let(:args) { {} }
    subject { block.url_text_input(**args) }

    it "adds a URL text input as the element" do
      expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::URLTextInput))
      expect(subject).to eq(block)
    end

    it "yields the URL text input" do
      expect { |b| block.url_text_input(**args, &b) }.to yield_with_args(BlockKit::Elements::URLTextInput)
    end

    context "with optional args" do
      let(:args) do
        {
          placeholder: "Enter a URL",
          initial_value: "https://example.com",
          focus_on_load: true,
          dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a URL text input with the given attributes" do
        expect { subject }.to change { block.element }.to(an_instance_of(BlockKit::Elements::URLTextInput))
        expect(block.element.placeholder.text).to eq("Enter a URL")
        expect(block.element.placeholder.emoji).to be false
        expect(block.element.initial_value).to eq("https://example.com")
        expect(block.element.focus_on_load).to be true
        expect(block.element.dispatch_action_config.trigger_actions_on).to eq(["on_enter_pressed"])
        expect(block.element.action_id).to eq("action_id")
      end
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        label: {type: "plain_text", text: "Name"},
        element: {
          type: "plain_text_input",
          placeholder: {type: "plain_text", text: "Enter your name"}
        }
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(hint: "This is a hint", optional: true, dispatch_action: true) }

      it "serializes to JSON" do
        expect(block.as_json).to eq({
          type: described_class.type.to_s,
          label: {type: "plain_text", text: "Name"},
          element: {
            type: "plain_text_input",
            placeholder: {type: "plain_text", text: "Enter your name"}
          },
          dispatch_action: true,
          hint: {type: "plain_text", text: "This is a hint"},
          optional: true
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:dispatch_action).with_type(:boolean) }
    it { is_expected.to have_attribute(:optional).with_type(:boolean) }

    it do
      is_expected.to have_attribute(:element).with_type(:block_kit_block).containing(
        :block_kit_channels_select,
        :block_kit_checkboxes,
        :block_kit_conversations_select,
        :block_kit_datepicker,
        :block_kit_datetimepicker,
        :block_kit_email_text_input,
        :block_kit_external_select,
        :block_kit_file_input,
        :block_kit_multi_channels_select,
        :block_kit_multi_conversations_select,
        :block_kit_multi_external_select,
        :block_kit_multi_static_select,
        :block_kit_multi_users_select,
        :block_kit_number_input,
        :block_kit_plain_text_input,
        :block_kit_radio_buttons,
        :block_kit_rich_text_input,
        :block_kit_static_select,
        :block_kit_timepicker,
        :block_kit_users_select,
        :block_kit_url_text_input
      )
    end

    it_behaves_like "a block with a block_id"
    it_behaves_like "a block that has plain text attributes", :label, :hint
    it_behaves_like "a block that has plain text emoji assignment", :label, :hint

    it "does not allow unsupported elements" do
      block.element = BlockKit::Elements::Button.new

      expect(block.element).to be_nil
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:hint).allow_nil }
    it { is_expected.to validate_length_of(:hint).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:element) }

    it "validates the associated element" do
      block.element.min_length = 10
      block.element.max_length = 5

      expect(block).not_to be_valid
      expect(block.errors[:element]).to include("is invalid: min_length must be less than or equal to max_length")
    end

    it "validates that dispatch_action is not true for FileInputs" do
      subject.element = BlockKit::Elements::FileInput.new
      expect(subject).to be_valid

      subject.dispatch_action = true
      expect(subject).not_to be_valid
      expect(subject.errors[:dispatch_action]).to include("can't be enabled for FileInputs")
    end
  end
end
