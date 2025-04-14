# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Section, type: :model do
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

  context "validations" do
    it { is_expected.to be_valid }
  end
end
