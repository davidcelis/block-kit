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

  it_behaves_like "a class that yields self on initialize"

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
    as: :datetimepicker,
    type: BlockKit::Elements::DatetimePicker,
    actual_fields: {
      initial_date_time: "2025-04-13T16:01:48Z",
      focus_on_load: true,
      confirm: {title: "Confirm"},
      action_id: "action_id"
    },
    expected_fields: {
      initial_date_time: Time.iso8601("2025-04-13T16:01:48Z"),
      focus_on_load: true,
      confirm: BlockKit::Composition::ConfirmationDialog.new(title: "Confirm"),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
    as: :rich_text_input,
    type: BlockKit::Elements::RichTextInput,
    actual_fields: {
      placeholder: "Type something",
      initial_value: BlockKit::Layout::RichText.new,
      focus_on_load: true,
      dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Type something", emoji: false),
      initial_value: BlockKit::Layout::RichText.new,
      focus_on_load: true,
      dispatch_action_config: BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"]),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
    attribute: :elements,
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
      expect(block.errors["elements[1]"]).to include("is invalid: options is invalid, options[2].text can't be blank")
    end

    it "validates the number of elements" do
      block.elements = Array.new(26) { BlockKit::Elements::Button.new(text: "Button", value: "button") }

      expect(block).not_to be_valid
      expect(block.errors[:elements]).to include("is too long (maximum is 25 elements)")
    end
  end

  context "fixers" do
    it "fixes associated elements" do
      block.button(text: "a" * (BlockKit::Elements::BaseButton::MAX_TEXT_LENGTH + 1), value: "button")
      expect(block).not_to be_valid

      block.fix_validation_errors

      expect(block.elements.last.text.length).to eq(BlockKit::Elements::BaseButton::MAX_TEXT_LENGTH)
    end

    it "automatically fixes too many elements with dangerous truncation" do
      subject.elements = (described_class::MAX_ELEMENTS + 1).times.map do |i|
        BlockKit::Elements::Button.new(text: "Button #{i + 1}")
      end

      expect {
        subject.fix_validation_errors
      }.not_to change {
        subject.elements.length
      }

      expect {
        subject.fix_validation_errors(dangerous: true)
      }.to change {
        subject.elements.length
      }.by(-1)
      expect(subject.elements.length).to eq(described_class::MAX_ELEMENTS)
      expect(subject.elements.last.text.text).to eq("Button #{described_class::MAX_ELEMENTS}")
    end
  end
end
