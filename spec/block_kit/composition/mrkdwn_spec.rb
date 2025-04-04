# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/block_kit/composition/mrkdwn" # TODO: remove this

RSpec.describe BlockKit::Composition::Mrkdwn do
  subject(:mrkdwn_block) { described_class.new }

  it "has a type" do
    expect(described_class::TYPE).to eq("mrkdwn")
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(mrkdwn_block.as_json).to eq({type: described_class::TYPE})
    end

    context "with all attributes" do
      let(:mrkdwn_block) { described_class.new(text: "Hello, world!", verbatim: false) }

      it "serializes to JSON" do
        expect(mrkdwn_block.as_json).to eq({
          type: described_class::TYPE,
          text: "Hello, world!",
          verbatim: false
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:string) }
    it { is_expected.to have_attribute(:verbatim).with_type(:boolean) }
  end
end
