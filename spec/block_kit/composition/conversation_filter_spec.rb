# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::ConversationFilter, type: :model do
  subject(:conversation_filter) { described_class.new(**attributes) }
  let(:attributes) do
    {
      exclude_external_shared_channels: true,
      exclude_bot_users: false
    }
  end

  it_behaves_like "a class that yields self on initialize"

  it "declares predicate and mutator methods for each include value" do
    described_class::VALID_INCLUDES.each do |value|
      expect(conversation_filter.public_send(:"include_#{value}?")).to be(false)
      conversation_filter.public_send(:"include_#{value}!")
      expect(conversation_filter.include).to include(value)
      expect(conversation_filter.public_send(:"include_#{value}?")).to be(true)
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(conversation_filter.as_json).to eq({
        exclude_external_shared_channels: true,
        exclude_bot_users: false
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(include: ["im", "mpim"]) }

      it "serializes to JSON" do
        expect(conversation_filter.as_json[:include]).to eq(["im", "mpim"])
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:include).with_type(:set).containing(:string) }
    it { is_expected.to have_attribute(:exclude_external_shared_channels).with_type(:boolean) }
    it { is_expected.to have_attribute(:exclude_bot_users).with_type(:boolean) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:include).allow_nil }
    it { is_expected.to validate_array_inclusion_of(:include).in_array(described_class::VALID_INCLUDES) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :include, null_value: {
      valid_values: [
        described_class::VALID_INCLUDES,
        described_class::VALID_INCLUDES.sample(rand(1..3)),
        nil
      ],
      invalid_values: [
        {before: ["im", "invalid", "mpim"], after: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["im", "mpim"])},
        {before: ["mpim", "nope", "public"], after: BlockKit::TypedSet.new(ActiveModel::Type::String.new, ["mpim", "public"])},
        {before: ["invalid"], after: nil},
        {before: [""], after: nil},
        {before: [], after: nil}
      ]
    }
  end
end
