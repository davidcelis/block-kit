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

  it_behaves_like "a class that yields self on initialize"

  it_behaves_like "a block that has a DSL method",
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
    as: :email_text_input,
    type: BlockKit::Elements::EmailTextInput,
    actual_fields: {
      placeholder: "Enter your email",
      initial_value: "hello@example.com",
      focus_on_load: true,
      dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Enter your email", emoji: false),
      initial_value: "hello@example.com",
      focus_on_load: true,
      dispatch_action_config: BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"]),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :element,
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
    attribute: :element,
    as: :file_input,
    type: BlockKit::Elements::FileInput,
    actual_fields: {
      filetypes: ["png", "jpg"],
      max_files: 3,
      action_id: "action_id"
    },
    expected_fields: {
      filetypes: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["png", "jpg"]),
      max_files: 3,
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
    as: :number_input,
    type: BlockKit::Elements::NumberInput,
    actual_fields: {
      placeholder: "Enter a number",
      is_decimal_allowed: false,
      initial_value: 5.0,
      min_value: 1.0,
      max_value: 10.0,
      focus_on_load: true,
      dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Enter a number", emoji: false),
      is_decimal_allowed: false,
      initial_value: 5,
      min_value: 1,
      max_value: 10,
      focus_on_load: true,
      dispatch_action_config: BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"]),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :element,
    as: :plain_text_input,
    type: BlockKit::Elements::PlainTextInput,
    actual_fields: {
      placeholder: "Enter your name",
      initial_value: "John Doe",
      min_length: 1,
      max_length: 50,
      multiline: false,
      focus_on_load: true,
      dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Enter your name", emoji: false),
      initial_value: "John Doe",
      min_length: 1,
      max_length: 50,
      multiline: false,
      focus_on_load: true,
      dispatch_action_config: BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"]),
      action_id: "action_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
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
    attribute: :element,
    as: :url_text_input,
    type: BlockKit::Elements::URLTextInput,
    actual_fields: {
      placeholder: "Enter a URL",
      initial_value: "https://example.com",
      focus_on_load: true,
      dispatch_action_config: {trigger_actions_on: [:on_enter_pressed]},
      emoji: false,
      action_id: "action_id"
    },
    expected_fields: {
      placeholder: BlockKit::Composition::PlainText.new(text: "Enter a URL", emoji: false),
      initial_value: "https://example.com",
      focus_on_load: true,
      dispatch_action_config: BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"]),
      action_id: "action_id"
    }

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

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :label, truncate: {maximum: described_class::MAX_LABEL_LENGTH}
    it_behaves_like "a block that fixes validation errors",
      attribute: :hint,
      truncate: {maximum: described_class::MAX_HINT_LENGTH},
      null_value: {
        valid_values: ["A hint", nil],
        invalid_values: [{before: "", after: nil}]
      }

    it "unsets dispatch_action for FileInputs" do
      block.element = BlockKit::Elements::FileInput.new
      block.dispatch_action = true
      expect(block).not_to be_valid

      expect { block.fix_validation_errors }.to change { block.dispatch_action }.from(true).to(false)
    end

    it "fixes associated element" do
      block.plain_text_input(placeholder: "a" * (BlockKit::Concerns::HasPlaceholder::MAX_TEXT_LENGTH + 1))
      expect(block).not_to be_valid

      expect {
        block.fix_validation_errors
      }.to change {
        block.element.placeholder.length
      }.by(-1)
    end
  end
end
