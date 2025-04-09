# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::FileInput, type: :model do
  subject(:input) { described_class.new(attributes) }
  let(:attributes) { {} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input.as_json).to eq({type: described_class::TYPE})
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          filetypes: ["jpg", "png"],
          max_files: 5
        )
      end

      it "serializes to JSON" do
        expect(input.as_json).to eq({
          type: described_class::TYPE,
          filetypes: ["jpg", "png"],
          max_files: 5
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:filetypes).with_type(:array, :string) }
    it { is_expected.to have_attribute(:max_files).with_type(:integer) }

    it_behaves_like "a block with an action_id"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:filetypes).allow_nil }
    it { is_expected.to validate_presence_of(:max_files).allow_nil }

    (1..10).each do |i|
      it { is_expected.to allow_value(i).for(:max_files) }
    end

    it { is_expected.not_to allow_value(0).for(:max_files).with_message("must be in 1..10") }
    it { is_expected.not_to allow_value(11).for(:max_files).with_message("must be in 1..10") }
  end
end
