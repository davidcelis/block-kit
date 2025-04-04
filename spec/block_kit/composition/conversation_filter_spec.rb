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
    it { is_expected.to have_attribute(:exclude_external_shared_channels).with_type(:boolean) }
    it { is_expected.to have_attribute(:exclude_bot_users).with_type(:boolean) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_inclusion_of(:include).in_array(described_class::VALID_INCLUDES) }
  end
end
