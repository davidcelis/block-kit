# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::MultiUsersSelect, type: :model do
  subject(:multi_users_select) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(multi_users_select.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) { super().merge(initial_users: ["U12345678", "U23456789"]) }

      it "serializes to JSON" do
        expect(multi_users_select.as_json).to eq({
          type: described_class.type.to_s,
          initial_users: ["U12345678", "U23456789"]
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_users).with_type(:set).containing(:string) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is confirmable"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
    it_behaves_like "a multi select"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates initial_users are all present" do
      multi_users_select.initial_users = ["C12345678", "", "C23456789", nil]

      expect(multi_users_select).not_to be_valid
      expect(multi_users_select.errors[:initial_users]).to include("must not contain blank values")
    end
  end

  context "fixers" do
    it "removes blank initial_users" do
      multi_users_select.initial_users = ["C12345678", "", "C23456789", nil]
      multi_users_select.fix_validation_errors

      expect(multi_users_select.initial_users.to_a).to eq(["C12345678", "C23456789"])
    end
  end
end
