# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Section, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:section) { described_class.new(**attributes) }

  describe "#initialize" do
    it "accepts text as a string and defaults to mrkdwn" do
      expect(section.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(section.text.type).to eq(:mrkdwn)
      expect(section.text.text).to eq("Hello, world!")
    end

    it "accepts text as a BlockKit::Composition::Text" do
      section.text = BlockKit::Composition::PlainText.new(text: "Hello, world!")
      expect(section.text).to be_a(BlockKit::Composition::PlainText)
      expect(section.text.type).to eq(:plain_text)
      expect(section.text.text).to eq("Hello, world!")

      section.text = BlockKit::Composition::Mrkdwn.new(text: "Hello, world!")
      expect(section.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(section.text.type).to eq(:mrkdwn)
    end

    it "accepts text as a Hash with attributes" do
      section.text = {type: "mrkdwn", text: "Hello, world!"}
      expect(section.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(section.text.type).to eq(:mrkdwn)
      expect(section.text.text).to eq("Hello, world!")

      section.text = {type: "plain_text", text: "Hello, world!"}
      expect(section.text).to be_a(BlockKit::Composition::PlainText)
      expect(section.text.type).to eq(:plain_text)
      expect(section.text.text).to eq("Hello, world!")

      section.text = {text: "Hello, world!"}
      expect(section.text).to be_a(BlockKit::Composition::Mrkdwn)
      expect(section.text.type).to eq(:mrkdwn)
      expect(section.text.text).to eq("Hello, world!")
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(section.as_json).to eq({
        type: described_class.type.to_s,
        text: {type: "mrkdwn", text: "Hello, world!"}
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          fields: [
            BlockKit::Composition::Mrkdwn.new(text: "Field 1"),
            BlockKit::Composition::PlainText.new(text: "Field 2")
          ],
          accessory: {type: "button", text: "Click me"},
          expand: false
        )
      end

      it "serializes all attributes" do
        expect(section.as_json).to eq({
          type: described_class.type.to_s,
          text: {type: "mrkdwn", text: "Hello, world!"},
          fields: [
            {type: "mrkdwn", text: "Field 1"},
            {type: "plain_text", text: "Field 2"}
          ],
          accessory: {type: "button", text: {type: "plain_text", text: "Click me"}},
          expand: false
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:block_kit_text) }
    it { is_expected.to have_attribute(:fields).with_type(:array).containing(:block_kit_text) }
    it do
      is_expected.to have_attribute(:accessory).with_type(:block_kit_block).containing(
        :block_kit_button,
        :block_kit_checkboxes,
        :block_kit_datepicker,
        :block_kit_image,
        :block_kit_multi_channels_select,
        :block_kit_multi_conversations_select,
        :block_kit_multi_external_select,
        :block_kit_multi_static_select,
        :block_kit_multi_users_select,
        :block_kit_overflow,
        :block_kit_radio_buttons,
        :block_kit_channels_select,
        :block_kit_conversations_select,
        :block_kit_external_select,
        :block_kit_static_select,
        :block_kit_users_select,
        :block_kit_timepicker,
        :block_kit_workflow_button
      )
    end

    it { is_expected.to have_attribute(:expand).with_type(:boolean) }

    it_behaves_like "a block with a block_id"
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text).allow_nil }
    it { is_expected.to validate_length_of(:text).is_at_most(3000) }
    it { is_expected.to validate_presence_of(:fields).allow_nil }

    it "validates that either text or fields is present" do
      section.text = ""
      section.fields = []

      expect(section).to be_invalid
      expect(section.errors[:base]).to include("must have either text or fields")
    end

    it "validates that there can't be more than 10 fields" do
      section.fields = Array.new(11) { BlockKit::Composition::Mrkdwn.new(text: "Field") }
      expect(section).to be_invalid
      expect(section.errors[:fields]).to include("is too long (maximum is 10 fields)")
    end

    it "validates that fields can't have more than 2000 characters" do
      section.fields = [
        BlockKit::Composition::Mrkdwn.new(text: "a" * 2000),
        BlockKit::Composition::PlainText.new(text: "a" * 2001),
        BlockKit::Composition::PlainText.new(text: "a" * 2000)
      ]

      expect(section).to be_invalid
      expect(section.errors["fields[0]"]).to be_empty
      expect(section.errors["fields[1]"]).to include("is invalid: text is too long (maximum is 2000 characters)")
      expect(section.errors["fields[2]"]).to be_empty
    end

    it "validates the accessory" do
      section.accessory = BlockKit::Elements::Image.new(image_url: "https://example.com/image.png")
      expect(section).to be_invalid
      expect(section.errors[:accessory]).to include("is invalid: alt_text can't be blank")
    end
  end
end
