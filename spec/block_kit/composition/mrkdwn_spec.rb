# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Mrkdwn, type: :model do
  subject(:mrkdwn_block) { described_class.new(**attributes) }
  let(:attributes) { {text: "Hello, world!"} }

  it_behaves_like "a class that yields self on initialize"

  describe "#truncate" do
    it "copies itself and truncates the copy's text" do
      mrkdwn_block.verbatim = true

      new_block = mrkdwn_block.truncate(8)
      expect(new_block).not_to eq(mrkdwn_block)
      expect(new_block.text).to eq("Hello...")
      expect(new_block.verbatim).to eq(true)

      expect(mrkdwn_block.text).to eq("Hello, world!")
      expect(mrkdwn_block.verbatim).to eq(true)
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(mrkdwn_block.as_json).to eq({
        type: described_class.type.to_s,
        text: "Hello, world!"
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(verbatim: false) }

      it "serializes to JSON" do
        expect(mrkdwn_block.as_json).to eq({
          type: described_class.type.to_s,
          text: "Hello, world!",
          verbatim: false
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
    it { is_expected.to have_attribute(:verbatim).with_type(:boolean) }
  end
end
