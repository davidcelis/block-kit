require "spec_helper"

RSpec.shared_examples_for "a conversation selector" do
  it { is_expected.to have_attribute(:default_to_current_conversation).with_type(:boolean) }
  it { is_expected.to have_attribute(:filter).with_type(:block_kit_conversation_filter) }

  it_behaves_like "a block that has a DSL method",
    attribute: :filter,
    type: BlockKit::Composition::ConversationFilter,
    actual_fields: {
      include: [:im, :mpim],
      exclude_external_shared_channels: true,
      exclude_bot_users: false
    },
    expected_fields: {
      include: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["im", "mpim"]),
      exclude_external_shared_channels: true,
      exclude_bot_users: false
    }

  describe "#as_json" do
    let(:attributes) do
      super().merge(
        default_to_current_conversation: true,
        filter: BlockKit::Composition::ConversationFilter.new(include: [:public, :private])
      )
    end

    it "serializes conversation selector attributes" do
      expect(subject.as_json).to include(
        default_to_current_conversation: true,
        filter: {include: ["public", "private"]}
      )
    end
  end

  it "validates the associated filter" do
    filter = BlockKit::Composition::ConversationFilter.new(include: [:public, :private])
    subject.filter = filter
    expect(subject).to be_valid

    subject.filter.include << "invalid"
    expect(subject).not_to be_valid
    expect(subject.errors[:filter]).to include("is invalid: include contains invalid values: \"invalid\"")
  end

  it_behaves_like "a block that fixes validation errors", attribute: :filter, associated: {
    record: -> {
      BlockKit::Composition::ConversationFilter.new(include: ["public", "invalid", "private"])
    },
    invalid_attribute: :include,
    fixed_attribute_value: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["public", "private"])
  }
end
