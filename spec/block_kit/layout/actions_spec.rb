# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Actions, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Elements::Button.new(text: "Button", value: "button"),
        BlockKit::Elements::StaticSelect.new(
          placeholder: "Select an option",
          options: [
            BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
            BlockKit::Composition::Option.new(text: "Option 2", value: "option_2")
          ]
        ),
        BlockKit::Elements::TimePicker.new(placeholder: "Select a time", initial_time: "12:00")
      ]
    }
  end

  describe "#button" do
    let(:args) { {} }
    subject { block.button(**args) }

    it "adds a button to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::Button)
    end

    it "yields the button" do
      expect { |b| block.button(**args, &b) }.to yield_with_args(BlockKit::Elements::Button)
    end

    context "with optional args" do
      let(:args) do
        {
          text: "Click me",
          value: "click_me",
          url: "https://example.com",
          emoji: false,
          style: "primary",
          accessibility_label: "Accessible label",
          action_id: "action_id"
        }
      end

      it "creates a button with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.text.text).to eq("Click me")
        expect(block.elements.last.text.emoji).to be false
        expect(block.elements.last.value).to eq("click_me")
        expect(block.elements.last.url).to eq("https://example.com")
        expect(block.elements.last.style).to eq("primary")
        expect(block.elements.last.accessibility_label).to eq("Accessible label")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#channels_select" do
    let(:args) { {} }
    subject { block.channels_select(**args) }

    it "adds a channels select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::ChannelsSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select a channel")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_channel).to eq("C12345678")
        expect(block.elements.last.response_url_enabled).to be true
        expect(block.elements.last.focus_on_load).to be false
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#checkboxes" do
    let(:args) { {} }
    subject { block.checkboxes(**args) }

    it "adds a checkboxes to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::Checkboxes)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.options.size).to eq(2)
        expect(block.elements.last.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.options.first.value).to eq("option_1")
        expect(block.elements.last.options.last.text.text).to eq("Option 2")
        expect(block.elements.last.options.last.value).to eq("option_2")
        expect(block.elements.last.options.last).to be_initial
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#conversations_select" do
    let(:args) { {} }
    subject { block.conversations_select(**args) }

    it "adds a conversations select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::ConversationsSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select a conversation")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_conversation).to eq("C12345678")
        expect(block.elements.last.default_to_current_conversation).to be true
        expect(block.elements.last.response_url_enabled).to be false
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.filter.include).to eq(["im", "public"])
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#datepicker" do
    let(:args) { {} }
    subject { block.datepicker(**args) }

    it "adds a datepicker to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::DatePicker)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select a date")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_date).to eq(Date.parse("2025-04-13"))
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#datetimepicker" do
    let(:args) { {} }
    subject { block.datetimepicker(**args) }

    it "adds a datetimepicker to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::DatetimePicker)
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

      it "creates a datepicker with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.initial_date_time).to eq(Time.iso8601("2025-04-13T16:01:48Z"))
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#external_select" do
    let(:args) { {} }
    subject { block.external_select(**args) }

    it "adds an external select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::ExternalSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select an option")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.min_query_length).to eq(3)
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_channels_select" do
    let(:args) { {} }
    subject { block.multi_channels_select(**args) }

    it "adds a channels select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::MultiChannelsSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select some channels")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_channels).to eq(["C12345678", "C23456789"])
        expect(block.elements.last.max_selected_items).to eq(3)
        expect(block.elements.last.focus_on_load).to be false
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_conversations_select" do
    let(:args) { {} }
    subject { block.multi_conversations_select(**args) }

    it "adds a conversations select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::MultiConversationsSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select some conversations")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_conversations).to eq(["C12345678", "C23456789"])
        expect(block.elements.last.max_selected_items).to eq(3)
        expect(block.elements.last.default_to_current_conversation).to be true
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.filter.include).to eq(["im", "public"])
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_external_select" do
    let(:args) { {} }
    subject { block.multi_external_select(**args) }

    it "adds an external select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::MultiExternalSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select some options")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.min_query_length).to eq(1)
        expect(block.elements.last.max_selected_items).to eq(3)
        expect(block.elements.last.initial_options.size).to eq(1)
        expect(block.elements.last.initial_options.first.text.text).to eq("Option 1")
        expect(block.elements.last.initial_options.first.value).to eq("option_1")
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_static_select" do
    let(:args) { {} }
    subject { block.multi_static_select(**args) }

    it "adds a static select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::MultiStaticSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select some options")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.max_selected_items).to eq(3)
        expect(block.elements.last.options.size).to eq(2)
        expect(block.elements.last.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.options.first.value).to eq("option_1")
        expect(block.elements.last.options.last.text.text).to eq("Option 2")
        expect(block.elements.last.options.last.value).to eq("option_2")
        expect(block.elements.last.options.last).to be_initial
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.option_groups.size).to eq(2)
        expect(block.elements.last.option_groups.first.label.text).to eq("Group 1")
        expect(block.elements.last.option_groups.first.options.size).to eq(1)
        expect(block.elements.last.option_groups.first.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.option_groups.first.options.first.value).to eq("option_1")
        expect(block.elements.last.option_groups.last.label.text).to eq("Group 2")
        expect(block.elements.last.option_groups.last.options.size).to eq(1)
        expect(block.elements.last.option_groups.last.options.first.text.text).to eq("Option 2")
        expect(block.elements.last.option_groups.last.options.first.value).to eq("option_2")
        expect(block.elements.last.option_groups.last.options.first).to be_initial
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
        expect(block.elements.last).not_to be_a(BlockKit::Elements::MultiStaticSelect)
      end
    end
  end

  describe "#multi_users_select" do
    let(:args) { {} }
    subject { block.multi_users_select(**args) }

    it "adds a users select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::MultiUsersSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select some users")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_users).to eq(["U12345678", "U23456789"])
        expect(block.elements.last.max_selected_items).to eq(3)
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#overflow" do
    let(:args) { {} }
    subject { block.overflow(**args) }

    it "adds an overflow to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::Overflow)
    end

    it "yields the overflow" do
      expect { |b| block.overflow(**args, &b) }.to yield_with_args(BlockKit::Elements::Overflow)
    end

    context "with optional args" do
      let(:args) do
        {
          options: [
            BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
            BlockKit::Composition::OverflowOption.new(text: "Option 2", value: "option_2", url: "https://example.com")
          ],
          confirm: {title: "Confirm"},
          action_id: "action_id"
        }
      end

      it "creates an overflow with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.options.size).to eq(2)
        expect(block.elements.last.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.options.first.value).to eq("option_1")
        expect(block.elements.last.options.last.text.text).to eq("Option 2")
        expect(block.elements.last.options.last.value).to eq("option_2")
        expect(block.elements.last.options.last.url).to eq("https://example.com")
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#radio_buttons" do
    let(:args) { {} }
    subject { block.radio_buttons(**args) }

    it "adds a radio buttons to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::RadioButtons)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.options.size).to eq(2)
        expect(block.elements.last.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.options.first.value).to eq("option_1")
        expect(block.elements.last.options.last.text.text).to eq("Option 2")
        expect(block.elements.last.options.last.value).to eq("option_2")
        expect(block.elements.last.options.last).to be_initial
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#rich_text_input" do
    let(:args) { {} }
    subject { block.rich_text_input(**args) }

    it "adds a rich text input to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::RichTextInput)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Type something")
        expect(block.elements.last.initial_value).to eq(args[:initial_value])
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.dispatch_action_config.trigger_actions_on).to eq(["on_enter_pressed"])
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#static_select" do
    let(:args) { {} }
    subject { block.static_select(**args) }

    it "adds a static select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::StaticSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select an option")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.options.size).to eq(2)
        expect(block.elements.last.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.options.first.value).to eq("option_1")
        expect(block.elements.last.options.last.text.text).to eq("Option 2")
        expect(block.elements.last.options.last.value).to eq("option_2")
        expect(block.elements.last.options.last).to be_initial
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.option_groups.size).to eq(2)
        expect(block.elements.last.option_groups.first.label.text).to eq("Group 1")
        expect(block.elements.last.option_groups.first.options.size).to eq(1)
        expect(block.elements.last.option_groups.first.options.first.text.text).to eq("Option 1")
        expect(block.elements.last.option_groups.first.options.first.value).to eq("option_1")
        expect(block.elements.last.option_groups.last.label.text).to eq("Group 2")
        expect(block.elements.last.option_groups.last.options.size).to eq(1)
        expect(block.elements.last.option_groups.last.options.first.text.text).to eq("Option 2")
        expect(block.elements.last.option_groups.last.options.first.value).to eq("option_2")
        expect(block.elements.last.option_groups.last.options.first).to be_initial
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
        expect(block.elements.last).not_to be_a(BlockKit::Elements::StaticSelect)
      end
    end
  end

  describe "#timepicker" do
    let(:args) { {} }
    subject { block.timepicker(**args) }

    it "adds a timepicker to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::TimePicker)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select a time")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_time).to eq(Time.parse("12:00 UTC").change(year: 2000, day: 1, month: 1))
        expect(block.elements.last.timezone).to eq(ActiveSupport::TimeZone["America/Los_Angeles"])
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#users_select" do
    let(:args) { {} }
    subject { block.users_select(**args) }

    it "adds a users select to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::UsersSelect)
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
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.placeholder.text).to eq("Select a user")
        expect(block.elements.last.placeholder.emoji).to be false
        expect(block.elements.last.initial_user).to eq("U12345678")
        expect(block.elements.last.focus_on_load).to be true
        expect(block.elements.last.confirm.title.text).to eq("Confirm")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#workflow_button" do
    let(:args) { {} }
    subject { block.workflow_button(**args) }

    it "adds a workflow button to the elements" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(block.elements.last).to be_a(BlockKit::Elements::WorkflowButton)
    end

    it "yields the workflow button" do
      expect { |b| block.workflow_button(**args, &b) }.to yield_with_args(BlockKit::Elements::WorkflowButton)
    end

    context "with optional args" do
      let(:args) do
        {
          text: "Click me",
          workflow: BlockKit::Composition::Workflow.new,
          style: "primary",
          accessibility_label: "Accessible label",
          emoji: false,
          action_id: "action_id"
        }
      end

      it "creates a workflow button with the given attributes" do
        expect { subject }.to change { block.elements.size }.by(1)
        expect(block.elements.last.text.text).to eq("Click me")
        expect(block.elements.last.text.emoji).to be false
        expect(block.elements.last.workflow).to eq(args[:workflow])
        expect(block.elements.last.style).to eq("primary")
        expect(block.elements.last.accessibility_label).to eq("Accessible label")
        expect(block.elements.last.action_id).to eq("action_id")
      end
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [
          {type: "button", text: {type: "plain_text", text: "Button"}, value: "button"},
          {type: "static_select", placeholder: {type: "plain_text", text: "Select an option"}, options: [
            {text: {type: "plain_text", text: "Option 1"}, value: "option_1"},
            {text: {type: "plain_text", text: "Option 2"}, value: "option_2"}
          ]},
          {type: "timepicker", placeholder: {type: "plain_text", text: "Select a time"}, initial_time: "12:00"}
        ]
      })
    end
  end

  context "attributes" do
    it do
      is_expected.to have_attribute(:elements).with_type(:array).containing(
        :block_kit_button,
        :block_kit_channels_select,
        :block_kit_checkboxes,
        :block_kit_conversations_select,
        :block_kit_datepicker,
        :block_kit_datetimepicker,
        :block_kit_external_select,
        :block_kit_multi_channels_select,
        :block_kit_multi_conversations_select,
        :block_kit_multi_external_select,
        :block_kit_multi_static_select,
        :block_kit_multi_users_select,
        :block_kit_overflow,
        :block_kit_radio_buttons,
        :block_kit_rich_text_input,
        :block_kit_static_select,
        :block_kit_timepicker,
        :block_kit_users_select,
        :block_kit_workflow_button
      )
    end

    it_behaves_like "a block with a block_id"

    it "does not allow unsupported elements" do
      expect {
        block.elements << BlockKit::Elements::PlainTextInput.new
      }.not_to change {
        block.elements.size
      }
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:elements) }

    it "validates elements" do
      block.elements[1].options << BlockKit::Composition::Option.new(text: "", value: "option_3")

      expect(block).not_to be_valid
      expect(block.errors["elements[1]"]).to include("is invalid: options[2].text can't be blank")
    end

    it "validates the number of elements" do
      block.elements = Array.new(26) { BlockKit::Elements::Button.new(text: "Button", value: "button") }

      expect(block).not_to be_valid
      expect(block.errors[:elements]).to include("is too long (maximum is 25 elements)")
    end
  end
end
