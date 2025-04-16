# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::PlainTextInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({type: described_class.type.to_s})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          initial_value: "Hello, world!",
          min_length: 1,
          max_length: 100,
          multiline: false
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class.type.to_s,
          initial_value: "Hello, world!",
          min_length: 1,
          max_length: 100,
          multiline: false
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:initial_value).with_type(:string) }
    it { is_expected.to have_attribute(:min_length).with_type(:integer) }
    it { is_expected.to have_attribute(:max_length).with_type(:integer) }
    it { is_expected.to have_attribute(:multiline).with_type(:boolean) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that is dispatchable"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:initial_value).allow_nil }

    context "initial_value" do
      it { is_expected.to validate_length_of(:initial_value).is_at_least(0).is_at_most(3000) }

      context "when min_length is set" do
        before { input.min_length = 5 }

        it { is_expected.to validate_length_of(:initial_value).is_at_least(5).is_at_most(3000) }
      end

      context "when max_length is set" do
        before { input.max_length = 10 }

        it { is_expected.to validate_length_of(:initial_value).is_at_least(0).is_at_most(10) }
      end

      context "when both min_length and max_length are set" do
        before do
          input.min_length = 5
          input.max_length = 10
        end

        it { is_expected.to validate_length_of(:initial_value).is_at_least(5).is_at_most(10) }
      end
    end

    context "min_length and max_length" do
      context "when min_length is greater than max_length" do
        before do
          input.min_length = 10
          input.max_length = 5
        end

        it "is not valid" do
          expect(input).not_to be_valid
          expect(input.errors[:min_length]).to include("must be less than or equal to max_length")
        end
      end

      context "when min_length is less than 0" do
        before { input.min_length = -1 }

        it "is not valid" do
          expect(input).not_to be_valid
          expect(input.errors[:min_length]).to include("must be in 0..3000")
        end
      end

      context "when max_length is less than 1" do
        before { input.max_length = 0 }

        it "is not valid" do
          expect(input).not_to be_valid
          expect(input.errors[:max_length]).to include("must be in 1..3000")
        end
      end

      context "when both min_length and max_length are set to valid values" do
        before do
          input.min_length = 5
          input.max_length = 10
        end

        it { is_expected.to be_valid }
      end
    end
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors",
      attribute: :initial_value,
      truncate: {maximum: 3000},
      null_value: {
        valid_values: ["anything", nil],
        invalid_values: [{before: "", after: nil}]
      }

    context "when max_length is set" do
      before { input.max_length = 10 }

      it_behaves_like "a block that fixes validation errors", attribute: :initial_value, truncate: {maximum: 10}
    end

    context "when min_length is set" do
      before { input.min_length = 5 }

      it_behaves_like "a block that fixes validation errors",
        attribute: :initial_value,
        null_value: {
          valid_values: ["Hello", nil],
          invalid_values: [{before: "Hell", after: nil}]
        }
    end
  end
end
