# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Emoji, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {name: "hotdog"} }

  it_behaves_like "a class that yields self on initialize"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({
        type: described_class.type.to_s,
        name: "hotdog"
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(unicode: "1F32D") }

      it "includes all attributes" do
        expect(element.as_json).to eq({
          type: described_class.type.to_s,
          name: "hotdog",
          unicode: "1f32d"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:name).with_type(:string) }
    it { is_expected.to have_attribute(:unicode).with_type(:string) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unicode).allow_nil }
    it { is_expected.to allow_value("1f2d").for(:unicode) }
    it { is_expected.to allow_value("1F32D-1f32e").for(:unicode) }
    it { is_expected.not_to allow_value("invalid").for(:unicode).with_message("is invalid") }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :unicode, null_value: {
      valid_values: ["1F32D-1f32e", "1f2d", nil],
      invalid_values: [
        {before: "invalid", after: "invalid", still_invalid: true},
        {before: "", after: nil}
      ]
    }
  end
end
