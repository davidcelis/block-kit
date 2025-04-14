require "spec_helper"

RSpec.shared_examples_for "a block that is dispatchable" do
  it { is_expected.to have_attribute(:dispatch_action_config).with_type(:block_kit_dispatch_action_config) }
  it { is_expected.to alias_attribute(:dispatch_action_config).as(:dispatch_action_configuration) }

  it_behaves_like "a block that has a DSL method",
    attribute: :dispatch_action_config,
    type: BlockKit::Composition::DispatchActionConfig,
    actual_fields: {trigger_actions_on: "on_enter_pressed"},
    expected_fields: {trigger_actions_on: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["on_enter_pressed"])}

  describe "#as_json" do
    it "serializes the dispatch_action_config in as JSON" do
      subject.dispatch_action_configuration = BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: ["on_enter_pressed"])

      expect(subject.as_json).to include(
        dispatch_action_config: {trigger_actions_on: ["on_enter_pressed"]}
      )
    end
  end

  it { is_expected.to validate_presence_of(:dispatch_action_config).allow_nil }

  it "validates the associated dispatch_action_config" do
    subject.dispatch_action_config = BlockKit::Composition::DispatchActionConfig.new(trigger_actions_on: [])
    expect(subject).not_to be_valid
    expect(subject.errors[:dispatch_action_config]).to include("is invalid: trigger_actions_on can't be blank")
  end
end
