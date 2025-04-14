# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Section, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:block) { described_class.new(**attributes) }

  describe "#initialize" do
    it "accepts text as a string and defaults to mrkdwn" do
      expect(block.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.text.type).to eq(:mrkdwn)
      expect(block.text.text).to eq("Hello, world!")
    end

    it "accepts text as a BlockKit::Composition::Text" do
      block.text = BlockKit::Composition::PlainText.new(text: "Hello, world!")
      expect(block.text).to be_a(BlockKit::Composition::PlainText)
      expect(block.text.type).to eq(:plain_text)
      expect(block.text.text).to eq("Hello, world!")

      block.text = BlockKit::Composition::Mrkdwn.new(text: "Hello, world!")
      expect(block.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.text.type).to eq(:mrkdwn)
    end

    it "accepts text as a Hash with attributes" do
      block.text = {type: "mrkdwn", text: "Hello, world!"}
      expect(block.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.text.type).to eq(:mrkdwn)
      expect(block.text.text).to eq("Hello, world!")

      block.text = {type: "plain_text", text: "Hello, world!"}
      expect(block.text).to be_a(BlockKit::Composition::PlainText)
      expect(block.text.type).to eq(:plain_text)
      expect(block.text.text).to eq("Hello, world!")

      block.text = {text: "Hello, world!"}
      expect(block.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.text.type).to eq(:mrkdwn)
      expect(block.text.text).to eq("Hello, world!")
    end
  end

  describe "#button" do
    let(:args) { {} }
    subject { block.button(**args) }

    it "adds a button as the accessory" do
      expect { subject }.to change { block.accessory }.to instance_of(BlockKit::Elements::Button)
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
        expect { subject }.to change { block.accessory }.to(instance_of(BlockKit::Elements::Button))
        expect(block.accessory.text.text).to eq("Click me")
        expect(block.accessory.text.emoji).to be false
        expect(block.accessory.value).to eq("click_me")
        expect(block.accessory.url).to eq("https://example.com")
        expect(block.accessory.style).to eq("primary")
        expect(block.accessory.accessibility_label).to eq("Accessible label")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#channels_select" do
    let(:args) { {} }
    subject { block.channels_select(**args) }

    it "adds a channels select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::ChannelsSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::ChannelsSelect))
        expect(block.accessory.placeholder.text).to eq("Select a channel")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_channel).to eq("C12345678")
        expect(block.accessory.response_url_enabled).to be true
        expect(block.accessory.focus_on_load).to be false
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#checkboxes" do
    let(:args) { {} }
    subject { block.checkboxes(**args) }

    it "adds a checkboxes as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::Checkboxes))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::Checkboxes))
        expect(block.accessory.options.size).to eq(2)
        expect(block.accessory.options.first.text.text).to eq("Option 1")
        expect(block.accessory.options.first.value).to eq("option_1")
        expect(block.accessory.options.last.text.text).to eq("Option 2")
        expect(block.accessory.options.last.value).to eq("option_2")
        expect(block.accessory.options.last).to be_initial
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#conversations_select" do
    let(:args) { {} }
    subject { block.conversations_select(**args) }

    it "adds a conversations select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::ConversationsSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::ConversationsSelect))
        expect(block.accessory.placeholder.text).to eq("Select a conversation")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_conversation).to eq("C12345678")
        expect(block.accessory.default_to_current_conversation).to be true
        expect(block.accessory.response_url_enabled).to be false
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.filter.include).to eq(["im", "public"])
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#datepicker" do
    let(:args) { {} }
    subject { block.datepicker(**args) }

    it "adds a datepicker as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::DatePicker))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::DatePicker))
        expect(block.accessory.placeholder.text).to eq("Select a date")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_date).to eq(Date.parse("2025-04-13"))
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#external_select" do
    let(:args) { {} }
    subject { block.external_select(**args) }

    it "adds an external select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::ExternalSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::ExternalSelect))
        expect(block.accessory.placeholder.text).to eq("Select an option")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_option.text.text).to eq("Option 1")
        expect(block.accessory.initial_option.value).to eq("option_1")
        expect(block.accessory.min_query_length).to eq(3)
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#image" do
    let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png"} }
    subject { block.image(**args) }

    it "adds an image as the accessory" do
      expect { subject }.to change { block.accessory }.to(instance_of(BlockKit::Elements::Image))
      expect(subject).to eq(block)

      expect(block.accessory).to be_a(BlockKit::Elements::Image)
      expect(block.accessory.alt_text).to eq("A beautiful image")
      expect(block.accessory.image_url).to eq("https://example.com/image.png")
    end

    context "with slack_file" do
      let(:args) { {alt_text: "A beautiful image", slack_file: BlockKit::Composition::SlackFile.new} }

      it "passes args to the image" do
        expect { subject }.to change { block.accessory }.to(instance_of(BlockKit::Elements::Image))

        expect(block.accessory.alt_text).to eq("A beautiful image")
        expect(block.accessory.slack_file).to eq(args[:slack_file])
        expect(block.accessory.image_url).to be_nil
      end
    end

    context "with both image_url and slack_file" do
      let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png", slack_file: BlockKit::Composition::SlackFile.new} }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Must provide either image_url or slack_file, but not both.")
      end
    end

    context "with neither image_url nor slack_file" do
      let(:args) { {alt_text: "A beautiful image"} }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Must provide either image_url or slack_file, but not both.")
      end
    end
  end

  describe "#multi_channels_select" do
    let(:args) { {} }
    subject { block.multi_channels_select(**args) }

    it "adds a channels select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiChannelsSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiChannelsSelect))
        expect(block.accessory.placeholder.text).to eq("Select some channels")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_channels).to eq(["C12345678", "C23456789"])
        expect(block.accessory.max_selected_items).to eq(3)
        expect(block.accessory.focus_on_load).to be false
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_conversations_select" do
    let(:args) { {} }
    subject { block.multi_conversations_select(**args) }

    it "adds a conversations select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiConversationsSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiConversationsSelect))
        expect(block.accessory.placeholder.text).to eq("Select some conversations")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_conversations).to eq(["C12345678", "C23456789"])
        expect(block.accessory.max_selected_items).to eq(3)
        expect(block.accessory.default_to_current_conversation).to be true
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.filter.include).to eq(["im", "public"])
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_external_select" do
    let(:args) { {} }
    subject { block.multi_external_select(**args) }

    it "adds an external select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiExternalSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiExternalSelect))
        expect(block.accessory.placeholder.text).to eq("Select some options")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.min_query_length).to eq(1)
        expect(block.accessory.max_selected_items).to eq(3)
        expect(block.accessory.initial_options.size).to eq(1)
        expect(block.accessory.initial_options.first.text.text).to eq("Option 1")
        expect(block.accessory.initial_options.first.value).to eq("option_1")
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#multi_static_select" do
    let(:args) { {} }
    subject { block.multi_static_select(**args) }

    it "adds a static select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiStaticSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiStaticSelect))
        expect(block.accessory.placeholder.text).to eq("Select some options")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.max_selected_items).to eq(3)
        expect(block.accessory.options.size).to eq(2)
        expect(block.accessory.options.first.text.text).to eq("Option 1")
        expect(block.accessory.options.first.value).to eq("option_1")
        expect(block.accessory.options.last.text.text).to eq("Option 2")
        expect(block.accessory.options.last.value).to eq("option_2")
        expect(block.accessory.options.last).to be_initial
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiStaticSelect))
        expect(block.accessory.option_groups.size).to eq(2)
        expect(block.accessory.option_groups.first.label.text).to eq("Group 1")
        expect(block.accessory.option_groups.first.options.size).to eq(1)
        expect(block.accessory.option_groups.first.options.first.text.text).to eq("Option 1")
        expect(block.accessory.option_groups.first.options.first.value).to eq("option_1")
        expect(block.accessory.option_groups.last.label.text).to eq("Group 2")
        expect(block.accessory.option_groups.last.options.size).to eq(1)
        expect(block.accessory.option_groups.last.options.first.text.text).to eq("Option 2")
        expect(block.accessory.option_groups.last.options.first.value).to eq("option_2")
        expect(block.accessory.option_groups.last.options.first).to be_initial
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
        expect(block.accessory).not_to be_a(BlockKit::Elements::MultiStaticSelect)
      end
    end
  end

  describe "#multi_users_select" do
    let(:args) { {} }
    subject { block.multi_users_select(**args) }

    it "adds a users select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiUsersSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::MultiUsersSelect))
        expect(block.accessory.placeholder.text).to eq("Select some users")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_users).to eq(["U12345678", "U23456789"])
        expect(block.accessory.max_selected_items).to eq(3)
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#overflow" do
    let(:args) { {} }
    subject { block.overflow(**args) }

    it "adds an overflow as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::Overflow))
      expect(block.accessory).to be_a(BlockKit::Elements::Overflow)
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::Overflow))
        expect(block.accessory.options.size).to eq(2)
        expect(block.accessory.options.first.text.text).to eq("Option 1")
        expect(block.accessory.options.first.value).to eq("option_1")
        expect(block.accessory.options.last.text.text).to eq("Option 2")
        expect(block.accessory.options.last.value).to eq("option_2")
        expect(block.accessory.options.last.url).to eq("https://example.com")
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#radio_buttons" do
    let(:args) { {} }
    subject { block.radio_buttons(**args) }

    it "adds a radio buttons as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::RadioButtons))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::RadioButtons))
        expect(block.accessory.options.size).to eq(2)
        expect(block.accessory.options.first.text.text).to eq("Option 1")
        expect(block.accessory.options.first.value).to eq("option_1")
        expect(block.accessory.options.last.text.text).to eq("Option 2")
        expect(block.accessory.options.last.value).to eq("option_2")
        expect(block.accessory.options.last).to be_initial
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#static_select" do
    let(:args) { {} }
    subject { block.static_select(**args) }

    it "adds a static select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::StaticSelect))
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::StaticSelect))
        expect(block.accessory.placeholder.text).to eq("Select an option")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.options.size).to eq(2)
        expect(block.accessory.options.first.text.text).to eq("Option 1")
        expect(block.accessory.options.first.value).to eq("option_1")
        expect(block.accessory.options.last.text.text).to eq("Option 2")
        expect(block.accessory.options.last.value).to eq("option_2")
        expect(block.accessory.options.last).to be_initial
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::StaticSelect))
        expect(block.accessory.option_groups.size).to eq(2)
        expect(block.accessory.option_groups.first.label.text).to eq("Group 1")
        expect(block.accessory.option_groups.first.options.size).to eq(1)
        expect(block.accessory.option_groups.first.options.first.text.text).to eq("Option 1")
        expect(block.accessory.option_groups.first.options.first.value).to eq("option_1")
        expect(block.accessory.option_groups.last.label.text).to eq("Group 2")
        expect(block.accessory.option_groups.last.options.size).to eq(1)
        expect(block.accessory.option_groups.last.options.first.text.text).to eq("Option 2")
        expect(block.accessory.option_groups.last.options.first.value).to eq("option_2")
        expect(block.accessory.option_groups.last.options.first).to be_initial
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
        expect(block.accessory).not_to be_a(BlockKit::Elements::StaticSelect)
      end
    end
  end

  describe "#timepicker" do
    let(:args) { {} }
    subject { block.timepicker(**args) }

    it "adds a timepicker as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::TimePicker))
      expect(block.accessory).to be_a(BlockKit::Elements::TimePicker)
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::TimePicker))
        expect(block.accessory.placeholder.text).to eq("Select a time")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_time).to eq(Time.parse("12:00 UTC").change(year: 2000, day: 1, month: 1))
        expect(block.accessory.timezone).to eq(ActiveSupport::TimeZone["America/Los_Angeles"])
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#users_select" do
    let(:args) { {} }
    subject { block.users_select(**args) }

    it "adds a users select as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::UsersSelect))
      expect(block.accessory).to be_a(BlockKit::Elements::UsersSelect)
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::UsersSelect))
        expect(block.accessory.placeholder.text).to eq("Select a user")
        expect(block.accessory.placeholder.emoji).to be false
        expect(block.accessory.initial_user).to eq("U12345678")
        expect(block.accessory.focus_on_load).to be true
        expect(block.accessory.confirm.title.text).to eq("Confirm")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#workflow_button" do
    let(:args) { {} }
    subject { block.workflow_button(**args) }

    it "adds a workflow button as the accessory" do
      expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::WorkflowButton))
      expect(block.accessory).to be_a(BlockKit::Elements::WorkflowButton)
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
        expect { subject }.to change { block.accessory }.to(an_instance_of(BlockKit::Elements::WorkflowButton))
        expect(block.accessory.text.text).to eq("Click me")
        expect(block.accessory.text.emoji).to be false
        expect(block.accessory.workflow).to eq(args[:workflow])
        expect(block.accessory.style).to eq("primary")
        expect(block.accessory.accessibility_label).to eq("Accessible label")
        expect(block.accessory.action_id).to eq("action_id")
      end
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        text: {type: "mrkdwn", text: "Hello, world!"}
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          fields: [
            BlockKit::Composition::Mrkdwn.new(text: "Field 1"),
            BlockKit::Composition::PlainText.new(text: "Field 2")
          ],
          accessory: {type: "button", text: "Click me"},
          expand: false
        )
      end

      it "serializes all attributes" do
        expect(block.as_json).to eq({
          type: described_class.type.to_s,
          text: {type: "mrkdwn", text: "Hello, world!"},
          fields: [
            {type: "mrkdwn", text: "Field 1"},
            {type: "plain_text", text: "Field 2"}
          ],
          accessory: {type: "button", text: {type: "plain_text", text: "Click me"}},
          expand: false
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:block_kit_text) }
    it { is_expected.to have_attribute(:fields).with_type(:array).containing(:block_kit_text) }
    it do
      is_expected.to have_attribute(:accessory).with_type(:block_kit_block).containing(
        :block_kit_button,
        :block_kit_checkboxes,
        :block_kit_datepicker,
        :block_kit_image,
        :block_kit_multi_channels_select,
        :block_kit_multi_conversations_select,
        :block_kit_multi_external_select,
        :block_kit_multi_static_select,
        :block_kit_multi_users_select,
        :block_kit_overflow,
        :block_kit_radio_buttons,
        :block_kit_channels_select,
        :block_kit_conversations_select,
        :block_kit_external_select,
        :block_kit_static_select,
        :block_kit_users_select,
        :block_kit_timepicker,
        :block_kit_workflow_button
      )
    end

    it { is_expected.to have_attribute(:expand).with_type(:boolean) }

    it_behaves_like "a block with a block_id"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text).allow_nil }
    it { is_expected.to validate_length_of(:text).is_at_most(3000) }
    it { is_expected.to validate_presence_of(:fields).allow_nil }

    it "validates that either text or fields is present" do
      block.text = ""
      block.fields = []

      expect(block).to be_invalid
      expect(block.errors[:base]).to include("must have either text or fields")
    end

    it "validates that there can't be more than 10 fields" do
      block.fields = Array.new(11) { BlockKit::Composition::Mrkdwn.new(text: "Field") }
      expect(block).to be_invalid
      expect(block.errors[:fields]).to include("is too long (maximum is 10 fields)")
    end

    it "validates that fields can't have more than 2000 characters" do
      block.fields = [
        BlockKit::Composition::Mrkdwn.new(text: "a" * 2000),
        BlockKit::Composition::PlainText.new(text: "a" * 2001),
        BlockKit::Composition::PlainText.new(text: "a" * 2000)
      ]

      expect(block).to be_invalid
      expect(block.errors["fields[0]"]).to be_empty
      expect(block.errors["fields[1]"]).to include("is invalid: text is too long (maximum is 2000 characters)")
      expect(block.errors["fields[2]"]).to be_empty
    end

    it "validates the accessory" do
      block.accessory = BlockKit::Elements::Image.new(image_url: "https://example.com/image.png")
      expect(block).to be_invalid
      expect(block.errors[:accessory]).to include("is invalid: alt_text can't be blank")
    end
  end
end
