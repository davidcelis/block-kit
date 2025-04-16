# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Markdown, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:markdown) { described_class.new(**attributes) }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(markdown.as_json).to eq({
        type: described_class.type.to_s,
        text: "Hello, world!"
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:string) }

    it_behaves_like "a block with a block_id"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(12_000) }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :text, truncate: {maximum: described_class::MAX_LENGTH}
  end
end
