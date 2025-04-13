# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::NumberInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({type: described_class.type.to_s})
    end

    context "as a decimal with all attributes" do
      let(:attributes) do
        super().merge(
          is_decimal_allowed: true,
          initial_value: 7.77,
          min_value: 0.1,
          max_value: 9.9
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class.type.to_s,
          is_decimal_allowed: true,
          initial_value: "7.77",
          min_value: "0.1",
          max_value: "9.9"
        })
      end
    end

    context "as an integer with all attributes" do
      let(:attributes) do
        super().merge(
          is_decimal_allowed: false,
          initial_value: 7.77,
          min_value: 0.1,
          max_value: 9.9
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class.type.to_s,
          is_decimal_allowed: false,
          initial_value: 7,
          min_value: 0,
          max_value: 9
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:is_decimal_allowed).with_type(:boolean) }
    it { is_expected.to have_attribute(:initial_value).with_type(:decimal) }
    it { is_expected.to have_attribute(:min_value).with_type(:decimal) }
    it { is_expected.to have_attribute(:max_value).with_type(:decimal) }

    it_behaves_like "a block with an action_id"
    it_behaves_like "a block that is focusable on load"
    it_behaves_like "a block that is dispatchable"
    it_behaves_like "a block that has a placeholder"
    it_behaves_like "a block that has plain text emoji assignment", :placeholder
  end

  context "validations" do
    it { is_expected.to be_valid }

    describe "numericality" do
      let(:min_value) { rand(0..5) }
      let(:max_value) { rand(5..10) }

      let(:attributes) do
        {
          min_value: min_value,
          max_value: max_value
        }
      end

      it { is_expected.to allow_value(min_value).for(:initial_value) }
      it { is_expected.to allow_value(max_value).for(:initial_value) }
      it { is_expected.to allow_value(nil).for(:initial_value) }
      it { is_expected.not_to allow_value(min_value - 1).for(:initial_value) }
      it { is_expected.not_to allow_value(max_value + 1).for(:initial_value) }

      it { is_expected.to allow_value(min_value).for(:min_value) }
      it { is_expected.to allow_value(nil).for(:min_value) }
      it { is_expected.not_to allow_value(max_value + 1).for(:min_value) }

      it { is_expected.to allow_value(max_value).for(:max_value) }
      it { is_expected.to allow_value(nil).for(:max_value) }
      it { is_expected.not_to allow_value(min_value - 1).for(:max_value) }

      context "when decimal is allowed" do
        let(:min_value) { rand(0.0..5.0) }
        let(:max_value) { rand(5.0..10.0) }

        let(:attributes) do
          {
            is_decimal_allowed: true,
            min_value: min_value,
            max_value: max_value
          }
        end

        it { is_expected.to allow_value(min_value).for(:initial_value) }
        it { is_expected.to allow_value(max_value).for(:initial_value) }
        it { is_expected.to allow_value(nil).for(:initial_value) }
        it { is_expected.not_to allow_value(min_value - 0.1).for(:initial_value) }
        it { is_expected.not_to allow_value(max_value + 0.1).for(:initial_value) }

        it { is_expected.to allow_value(min_value).for(:min_value) }
        it { is_expected.to allow_value(nil).for(:min_value) }
        it { is_expected.not_to allow_value(max_value + 0.1).for(:min_value) }

        it { is_expected.to allow_value(max_value).for(:max_value) }
        it { is_expected.to allow_value(nil).for(:max_value) }
        it { is_expected.not_to allow_value(min_value - 0.1).for(:max_value) }
      end
    end
  end
end
