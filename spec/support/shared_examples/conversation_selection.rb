require "spec_helper"

RSpec.shared_examples_for "a conversation selector" do
  it { is_expected.to have_attribute(:default_to_current_conversation).with_type(:boolean) }
  it { is_expected.to have_attribute(:filter).with_type(:block_kit_conversation_filter) }

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
end
