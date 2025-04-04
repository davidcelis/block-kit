# frozen_string_literal: true

require "spec_helper"
require "block_kit/composition/dialog"

RSpec.describe BlockKit::Composition::Dialog do
  let(:attributes) do
    {
      title: "Dialog Title",
      text: "Dialog Text",
      confirm: "Yes",
      deny: "No",
      style: "primary"
    }
  end

  subject(:dialog) { described_class.new(attributes) }

  it "serializes to JSON" do
    expect(dialog.as_json).to eq({
      title: {type: "plain_text", text: "Dialog Title"},
      text: {type: "plain_text", text: "Dialog Text"},
      confirm: {type: "plain_text", text: "Yes"},
      deny: {type: "plain_text", text: "No"},
      style: "primary"
    })
  end

  context "validations" do
    it { is_expected.to be_valid }

    it "validates the presence of a title" do
      dialog.title = nil
      expect(dialog).not_to be_valid
      expect(dialog.errors[:title]).to include("can't be blank")

      dialog.title = " "
      expect(dialog).not_to be_valid
      expect(dialog.errors[:title]).to include("can't be blank")

      dialog.title = "a" * 101
      expect(dialog).not_to be_valid
      expect(dialog.errors[:title]).to include("is too long (maximum is 100 characters)")
    end

    it "validates the presence of text" do
      dialog.text = nil
      expect(dialog).not_to be_valid
      expect(dialog.errors[:text]).to include("can't be blank")

      dialog.text = " "
      expect(dialog).not_to be_valid
      expect(dialog.errors[:text]).to include("can't be blank")

      dialog.text = "a" * 301
      expect(dialog).not_to be_valid
      expect(dialog.errors[:text]).to include("is too long (maximum is 300 characters)")
    end

    it "validates the presence of confirm" do
      dialog.confirm = nil
      expect(dialog).not_to be_valid
      expect(dialog.errors[:confirm]).to include("can't be blank")

      dialog.confirm = " "
      expect(dialog).not_to be_valid
      expect(dialog.errors[:confirm]).to include("can't be blank")

      dialog.confirm = "a" * 31
      expect(dialog).not_to be_valid
      expect(dialog.errors[:confirm]).to include("is too long (maximum is 30 characters)")
    end

    it "validates the presence of deny" do
      dialog.deny = nil
      expect(dialog).not_to be_valid
      expect(dialog.errors[:deny]).to include("can't be blank")

      dialog.deny = " "
      expect(dialog).not_to be_valid
      expect(dialog.errors[:deny]).to include("can't be blank")

      dialog.deny = "a" * 31
      expect(dialog).not_to be_valid
      expect(dialog.errors[:deny]).to include("is too long (maximum is 30 characters)")
    end

    it "validates the inclusion of style" do
      dialog.style = "invalid_style"
      expect(dialog).not_to be_valid
      expect(dialog.errors[:style]).to include("is not included in the list")

      dialog.style = nil
      expect(dialog).to be_valid

      dialog.style = "primary"
      expect(dialog).to be_valid

      dialog.style = "danger"
      expect(dialog).to be_valid
    end
  end
end
