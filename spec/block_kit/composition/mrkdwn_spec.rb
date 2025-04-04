# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Mrkdwn do
  subject(:mrkdwn_block) { described_class.new }

  it "has a type" do
    expect(described_class::TYPE).to eq("mrkdwn")
  end

  it "serializes to JSON" do
    expect(mrkdwn_block.as_json).to eq({type: described_class::TYPE})
  end

  it { is_expected.to be_valid }

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
