# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::EmailTextInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  it_behaves_like "a class that yields self on initialize"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) { super().merge(initial_value: "hello@example.com") }

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class.type.to_s,
          initial_value: "hello@example.com"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_value).with_type(:string) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that is dispatchable"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_value).allow_nil }
    it { is_expected.to allow_value("hello@example.com").for(:initial_value) }
    it { is_expected.not_to allow_value("invalidemail.com").for(:initial_value) }
    it { is_expected.not_to allow_value("invalidemail@.com").for(:initial_value) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :initial_value, null_value: {
      valid_values: ["hello@example.com", nil],
      invalid_values: [
        {before: "invalidemail@.com", after: nil},
        {before: "", after: nil}
      ]
    }
  end
end
