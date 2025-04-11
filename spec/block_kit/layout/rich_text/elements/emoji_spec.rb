# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::Emoji, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {name: "hotdog"} }

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
          unicode: "1F32D"
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
  end
end
