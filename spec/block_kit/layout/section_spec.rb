# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Section, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:block) { described_class.new(**attributes) }

  it_behaves_like "a class that yields self on initialize"

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

  describe "#mrkdwn" do
    let(:args) { {text: "Hello, world!"} }
    subject { block.mrkdwn(**args) }

    it "adds a mrkdwn text as the text" do
      expect { subject }.to change { block.text }.to(instance_of(BlockKit::Composition::Mrkdwn))
      expect(block.text.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(verbatim: false) }

      it "creates a mrkdwn text with the given attributes" do
        expect { subject }.to change { block.text }.to(instance_of(BlockKit::Composition::Mrkdwn))
        expect(block.text.text).to eq("Hello, world!")
        expect(block.text.verbatim).to be false
      end
    end
  end

  describe "#plain_text" do
    let(:args) { {text: "Hello, world!"} }
    subject { block.plain_text(**args) }

    it "adds a plain_text text as the text" do
      expect { subject }.to change { block.text }.to(instance_of(BlockKit::Composition::PlainText))
      expect(block.text.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(emoji: false) }

      it "creates a plain_text with the given attributes" do
        expect { subject }.to change { block.text }.to(instance_of(BlockKit::Composition::PlainText))
        expect(block.text.text).to eq("Hello, world!")
        expect(block.text.emoji).to be false
      end
    end
  end

  describe "#mrkdwn_field" do
    let(:args) { {text: "Hello, world!"} }
    subject { block.mrkdwn_field(**args) }

    it "adds a mrkdwn text to the section's fields" do
      expect { subject }.to change { block.fields&.count }.from(nil).to(1)
      expect(block.fields.last).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.fields.last.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(verbatim: false) }

      it "creates a mrkdwn field with the given attributes" do
        expect { subject }.to change { block.fields&.count }.from(nil).to(1)
        expect(block.fields.last).to be_a(BlockKit::Composition::Mrkdwn)
        expect(block.fields.last.text).to eq("Hello, world!")
        expect(block.fields.last.verbatim).to be false
      end
    end
  end

  describe "#plain_text_field" do
    let(:args) { {text: "Hello, world!"} }
    subject { block.plain_text_field(**args) }

    it "adds a plain_text object to the section's fields" do
      expect { subject }.to change { block.fields&.count }.from(nil).to(1)
      expect(block.fields.last).to be_a(BlockKit::Composition::PlainText)
      expect(block.fields.last.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(emoji: false) }

      it "creates a plain_text field with the given attributes" do
        expect { subject }.to change { block.fields&.count }.from(nil).to(1)
        expect(block.fields.last).to be_a(BlockKit::Composition::PlainText)
        expect(block.fields.last.text).to eq("Hello, world!")
        expect(block.fields.last.emoji).to be false
      end
    end
  end

  describe "#field" do
    let(:args) { {text: "Hello, world!"} }
    subject { block.field(**args) }

    it "adds a mrkdwn text to the section's fields" do
      expect { subject }.to change { block.fields&.count }.from(nil).to(1)
      expect(block.fields.last).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.fields.last.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(verbatim: true, emoji: false) }

      it "creates a mrkdwn field with the relevant attributes" do
        expect { subject }.to change { block.fields&.count }.from(nil).to(1)
        expect(block.fields.last).to be_a(BlockKit::Composition::Mrkdwn)
        expect(block.fields.last.text).to eq("Hello, world!")
        expect(block.fields.last.verbatim).to be true
      end
    end

    context "with plain_text" do
      let(:args) { super().merge(type: :plain_text) }

      it "adds a plain_text object to the section's fields" do
        expect { subject }.to change { block.fields&.count }.from(nil).to(1)
        expect(block.fields.last).to be_a(BlockKit::Composition::PlainText)
        expect(block.fields.last.text).to eq("Hello, world!")
      end

      context "with optional args" do
        let(:args) { super().merge(emoji: true, verbatim: false) }

        it "creates a plain_text field with the given attributes" do
          expect { subject }.to change { block.fields&.count }.from(nil).to(1)
          expect(block.fields.last).to be_a(BlockKit::Composition::PlainText)
          expect(block.fields.last.text).to eq("Hello, world!")
          expect(block.fields.last.emoji).to be true
        end
      end
    end

    context "with an invalid type" do
      let(:args) { super().merge(type: :invalid_type) }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Invalid field type: invalid_type (must be mrkdwn or plain_text)")
      end
    end
  end

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :button,
    type: BlockKit::Elements::Button,
    required_fields: [:text],
    actual_fields: {text: "Click me", value: "click_me", url: "https://example.com", style: "primary", accessibility_label: "Accessible label", action_id: "action_id", emoji: false},
    expected_fields: {
      text: BlockKit::Composition::PlainText.new(text: "Click me", emoji: false),
      value: "click_me",
      url: "https://example.com",
      style: "primary",
      accessibility_label: "Accessible label",
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :channels_select,
    type: BlockKit::Elements::ChannelsSelect,
    actual_fields: {placeholder: "Select a channel", initial_channel: "C12345678", response_url_enabled: true, focus_on_load: false, confirm: {title: "Confirm"}, emoji: false, action_id: "action_id"},
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select a channel", emoji: false),
      initial_channel: "C12345678",
      response_url_enabled: true,
      focus_on_load: false,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :checkboxes,
    type: BlockKit::Elements::Checkboxes,
    actual_fields: {
      options: [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2", initial: true}
      ],
      focus_on_load: true,
      confirm: {title: "Confirm"},
      action_id: "action_id"
    },
    expected_fields: {
      options: [
        BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
        BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
      ],
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :conversations_select,
    type: BlockKit::Elements::ConversationsSelect,
    actual_fields: {
      placeholder: "Select a conversation",
      initial_conversation: "C12345678",
      default_to_current_conversation: true,
      response_url_enabled: false,
      focus_on_load: true,
      confirm: {title: "Confirm"},
      filter: {include: [:im, :public]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select a conversation", emoji: false),
      initial_conversation: "C12345678",
      default_to_current_conversation: true,
      response_url_enabled: false,
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      filter: BlockKit::Composition::ConversationFilter.new(include: ["im", "public"]),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :datepicker,
    type: BlockKit::Elements::DatePicker,
    actual_fields: {
      placeholder: "Select a date",
      initial_date: "2025-04-13",
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select a date", emoji: false),
      initial_date: Date.parse("2025-04-13"),
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :external_select,
    type: BlockKit::Elements::ExternalSelect,
    actual_fields: {
      placeholder: "Select an option",
      initial_option: {text: "Option 1", value: "option_1"},
      min_query_length: 3,
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select an option", emoji: false),
      initial_option: BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
      min_query_length: 3,
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

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

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :multi_channels_select,
    type: BlockKit::Elements::MultiChannelsSelect,
    actual_fields: {
      placeholder: "Select some channels",
      initial_channels: ["C12345678", "C23456789"],
      max_selected_items: 3,
      focus_on_load: false,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some channels", emoji: false),
      initial_channels: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["C12345678", "C23456789"]),
      max_selected_items: 3,
      focus_on_load: false,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :multi_conversations_select,
    type: BlockKit::Elements::MultiConversationsSelect,
    actual_fields: {
      placeholder: "Select some conversations",
      initial_conversations: ["C12345678", "C23456789"],
      max_selected_items: 3,
      default_to_current_conversation: true,
      focus_on_load: true,
      confirm: {title: "Confirm"},
      filter: {include: [:im, :public]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some conversations", emoji: false),
      initial_conversations: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["C12345678", "C23456789"]),
      max_selected_items: 3,
      default_to_current_conversation: true,
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      filter: BlockKit::Composition::ConversationFilter.new(include: ["im", "public"]),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :multi_external_select,
    type: BlockKit::Elements::MultiExternalSelect,
    actual_fields: {
      placeholder: "Select some options",
      initial_options: [{text: "Option 1", value: "option_1"}],
      min_query_length: 1,
      max_selected_items: 3,
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some options", emoji: false),
      initial_options: [BlockKit::Composition::Option.new(text: "Option 1", value: "option_1")],
      min_query_length: 1,
      max_selected_items: 3,
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :multi_static_select,
    type: BlockKit::Elements::MultiStaticSelect,
    actual_fields: {
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
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some options", emoji: false),
      options: [
        BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
        BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
      ],
      max_selected_items: 3,
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    },
    mutually_exclusive_fields: [:options, :option_groups]

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :multi_static_select,
    type: BlockKit::Elements::MultiStaticSelect,
    actual_fields: {
      placeholder: "Select some options",
      option_groups: [
        {label: "Group 1", options: [{text: "Option 1", value: "option_1"}]},
        {label: "Group 2", options: [{text: "Option 2", value: "option_2", initial: true}]}
      ],
      max_selected_items: 3,
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some options", emoji: false),
      option_groups: [
        BlockKit::Composition::OptionGroup.new(label: "Group 1", options: [BlockKit::Composition::Option.new(text: "Option 1", value: "option_1")]),
        BlockKit::Composition::OptionGroup.new(label: "Group 2", options: [BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)])
      ],
      max_selected_items: 3,
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    },
    mutually_exclusive_fields: [:options, :option_groups]

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :multi_users_select,
    type: BlockKit::Elements::MultiUsersSelect,
    actual_fields: {
      placeholder: "Select some users",
      initial_users: ["U12345678", "U23456789"],
      max_selected_items: 3,
      focus_on_load: false,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some users", emoji: false),
      initial_users: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["U12345678", "U23456789"]),
      max_selected_items: 3,
      focus_on_load: false,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :overflow,
    type: BlockKit::Elements::Overflow,
    actual_fields: {
      options: [
        BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
        BlockKit::Composition::OverflowOption.new(text: "Option 2", value: "option_2", url: "https://example.com")
      ],
      confirm: {title: "Confirm"},
      action_id: "action_id"
    },
    expected_fields: {
      options: [
        BlockKit::Composition::OverflowOption.new(text: "Option 1", value: "option_1"),
        BlockKit::Composition::OverflowOption.new(text: "Option 2", value: "option_2", url: "https://example.com")
      ],
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :radio_buttons,
    type: BlockKit::Elements::RadioButtons,
    actual_fields: {
      options: [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2", initial: true}
      ],
      focus_on_load: true,
      confirm: {title: "Confirm"},
      action_id: "action_id"
    },
    expected_fields: {
      options: [
        BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
        BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
      ],
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :static_select,
    type: BlockKit::Elements::StaticSelect,
    actual_fields: {
      placeholder: "Select some options",
      options: [
        {text: "Option 1", value: "option_1"},
        {text: "Option 2", value: "option_2", initial: true}
      ],
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some options", emoji: false),
      options: [
        BlockKit::Composition::Option.new(text: "Option 1", value: "option_1"),
        BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)
      ],
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    },
    mutually_exclusive_fields: [:options, :option_groups]

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :static_select,
    type: BlockKit::Elements::StaticSelect,
    actual_fields: {
      placeholder: "Select some options",
      option_groups: [
        {label: "Group 1", options: [{text: "Option 1", value: "option_1"}]},
        {label: "Group 2", options: [{text: "Option 2", value: "option_2", initial: true}]}
      ],
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select some options", emoji: false),
      option_groups: [
        BlockKit::Composition::OptionGroup.new(label: "Group 1", options: [BlockKit::Composition::Option.new(text: "Option 1", value: "option_1")]),
        BlockKit::Composition::OptionGroup.new(label: "Group 2", options: [BlockKit::Composition::Option.new(text: "Option 2", value: "option_2", initial: true)])
      ],
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    },
    mutually_exclusive_fields: [:options, :option_groups]

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :timepicker,
    type: BlockKit::Elements::TimePicker,
    actual_fields: {
      placeholder: "Select a time",
      initial_time: "12:00",
      timezone: "America/Los_Angeles",
      focus_on_load: true,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select a time", emoji: false),
      initial_time: Time.parse("12:00 UTC").change(year: 2000, day: 1, month: 1),
      timezone: ActiveSupport::TimeZone["America/Los_Angeles"],
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :users_select,
    type: BlockKit::Elements::UsersSelect,
    actual_fields: {
      placeholder: "Select a user",
      initial_user: "U12345678",
      focus_on_load: false,
      confirm: {title: "Confirm"},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Select a user", emoji: false),
      initial_user: "U12345678",
      focus_on_load: false,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :accessory,
    as: :workflow_button,
    type: BlockKit::Elements::WorkflowButton,
    actual_fields: {
      text: "Click me",
      workflow: BlockKit::Composition::Workflow.new,
      style: "primary",
      accessibility_label: "Accessible label",
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      text: BlockKit::Composition::PlainText.new(text: "Click me", emoji: false),
      workflow: BlockKit::Composition::Workflow.new,
      style: "primary",
      accessibility_label: "Accessible label",
      emoji: false,
      action_id: "action_id"
    }

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

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :text, truncate: {maximum: described_class::MAX_TEXT_LENGTH}

    it "truncates the fields array when there are too many fields" do
      subject.fields = (described_class::MAX_FIELDS + 1).times.map do |i|
        BlockKit::Composition::PlainText.new(text: "Field #{i + 1}")
      end

      expect {
        subject.fix_validation_errors
      }.to change {
        subject.fields.length
      }.by(-1)
      expect(subject.fields.length).to eq(described_class::MAX_FIELDS)
      expect(subject.fields.last.text).to eq("Field #{described_class::MAX_FIELDS}")
    end

    it "truncates long fields" do
      block.fields = [
        BlockKit::Composition::Mrkdwn.new(text: "a" * described_class::MAX_FIELD_TEXT_LENGTH),
        BlockKit::Composition::PlainText.new(text: "a" * (described_class::MAX_FIELD_TEXT_LENGTH + 1)),
        BlockKit::Composition::PlainText.new(text: "a" * described_class::MAX_FIELD_TEXT_LENGTH),
        BlockKit::Composition::Mrkdwn.new(text: "a" * (described_class::MAX_FIELD_TEXT_LENGTH + 2))
      ]

      block.fix_validation_errors

      expect(block.fields[1].text.length).to eq(described_class::MAX_FIELD_TEXT_LENGTH)
      expect(block.fields[3].text.length).to eq(described_class::MAX_FIELD_TEXT_LENGTH)
    end

    it "removes blank fields" do
      block.fields = [
        BlockKit::Composition::Mrkdwn.new(text: "Field 1"),
        BlockKit::Composition::PlainText.new(text: ""),
        BlockKit::Composition::PlainText.new(text: "Field 2"),
        BlockKit::Composition::Mrkdwn.new(text: nil)
      ]

      expect { block.fix_validation_errors }.to change { block.fields.count }.by(-2)

      expect(block.fields.map(&:text)).to eq(["Field 1", "Field 2"])
    end

    it_behaves_like "a block that fixes validation errors", attribute: :accessory, associated: {
      record: -> {
        BlockKit::Elements::Button.new(text: "a" * (BlockKit::Elements::BaseButton::MAX_TEXT_LENGTH + 1), value: "button")
      },
      invalid_attribute: :text,
      fixed_attribute_value: BlockKit::Composition::PlainText.new(text: "a" * (BlockKit::Elements::BaseButton::MAX_TEXT_LENGTH - 3) + "...")
    }
  end
end
