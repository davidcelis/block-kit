# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::PlainText, type: :model do
  subject(:plain_text_block) { described_class.new(**attributes) }
  let(:attributes) { {text: "Hello, world!"} }

  it_behaves_like "a class that yields self on initialize"

  describe "#truncate" do
    it "copies itself and truncates the copy's text" do
      plain_text_block.emoji = true

      new_block = plain_text_block.truncate(8)
      expect(new_block).not_to eq(plain_text_block)
      expect(new_block.text).to eq("Hello...")
      expect(new_block.emoji).to eq(true)

      expect(plain_text_block.text).to eq("Hello, world!")
      expect(plain_text_block.emoji).to eq(true)
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(plain_text_block.as_json).to eq({
        type: described_class.type.to_s,
        text: "Hello, world!"
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(emoji: false) }

      it "serializes to JSON" do
        expect(plain_text_block.as_json).to eq({
          type: described_class.type.to_s,
          text: "Hello, world!",
          emoji: false
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(described_class::MAX_LENGTH) }
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:string) }
    it { is_expected.to have_attribute(:emoji).with_type(:boolean) }
  end
end
