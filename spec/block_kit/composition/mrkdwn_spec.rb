# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Mrkdwn do
  subject(:mrkdwn_block) { described_class.new(**attributes) }
  let(:attributes) { {text: "Hello, world!"} }

  it "has a type" do
    expect(described_class.type.to_s).to eq("mrkdwn")
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
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:string) }
    it { is_expected.to have_attribute(:verbatim).with_type(:boolean) }
  end
end
