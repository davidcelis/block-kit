# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Preformatted, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) { {elements: [BlockKit::Layout::RichText::Elements::Text.new(text: "Hello, world!")]} }

  it_behaves_like "a block that has rich text elements"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [{type: "text", text: "Hello, world!"}]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:border).with_type(:integer) }
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to allow_value(1).for(:border) }
    it { is_expected.to allow_value(0).for(:border) }
    it { is_expected.not_to allow_value(-1).for(:border) }
    it { is_expected.to allow_value(nil).for(:border) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :border, null_value: {
      valid_values: [nil, 0, 1, 2, 3],
      invalid_values: [
        {before: -1, after: nil},
        {before: -2, after: nil},
        {before: -3, after: nil}
      ]
    }
  end
end
