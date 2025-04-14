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

  describe "array mutation" do
    let(:attributes) { super().merge(include: ["im"]) }

    it "handles pushing new values" do
      conversation_filter.include << :mpim
      expect(conversation_filter.include.to_a).to eq(["im", "mpim"])
    end

    it "handles assignment with symbols" do
      conversation_filter.include = [:public, :private]
      expect(conversation_filter.include.to_a).to eq(["public", "private"])
    end

    it "handles appending arrays" do
      conversation_filter.include += [:public, :private]
      expect(conversation_filter.include.to_a).to eq(["im", "public", "private"])
    end
  end
end
