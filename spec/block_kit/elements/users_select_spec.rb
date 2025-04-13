# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::UsersSelect, type: :model do
  subject(:users_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(users_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) { super().merge(initial_user: "U12345678") }

      it "serializes to JSON" do
        expect(users_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_user: "U12345678"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_user).with_type(:string) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_user).allow_nil }
  end
end
