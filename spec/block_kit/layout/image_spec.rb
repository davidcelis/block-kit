# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Image, type: :model do
  subject(:image) { described_class.new(attributes) }
  let(:attributes) do
    {
      alt_text: "An image",
      image_url: "https://example.com/image.png"
    }
  end

  describe "#slack_file" do
    it "sets the slack_file attribute by ID" do
      image.slack_file(id: "F12345678")

      expect(image.slack_file).to be_a(BlockKit::Composition::SlackFile)
      expect(image.slack_file.id).to eq("F12345678")
      expect(image.slack_file.url).to be_nil
    end

    it "sets the slack_file attribute by URL" do
      image.slack_file(url: "https://example.com/image.png")
      expect(image.slack_file).to be_a(BlockKit::Composition::SlackFile)
      expect(image.slack_file.id).to be_nil
      expect(image.slack_file.url).to eq("https://example.com/image.png")
    end

    it "raises an error if both id and url are provided" do
      expect {
        image.slack_file(id: "F12345678", url: "https://example.com/image.png")
      }.to raise_error(ArgumentError, "mutually exclusive keywords: :id, :url")
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(image.as_json).to eq({
        type: described_class.type.to_s,
        alt_text: "An image",
        image_url: "https://example.com/image.png"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        {
          alt_text: "An image",
          slack_file: BlockKit::Composition::SlackFile.new(id: "F12345678"),
          title: "Image title"
        }
      end

      it "serializes to JSON" do
        expect(image.as_json).to eq({
          type: described_class.type.to_s,
          alt_text: "An image",
          slack_file: {id: "F12345678"},
          title: {type: "plain_text", text: "Image title"}
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:alt_text).with_type(:string) }
    it { is_expected.to have_attribute(:image_url).with_type(:string) }
    it { is_expected.to have_attribute(:slack_file).with_type(:block_kit_slack_file) }

    it_behaves_like "a block with a block_id"
    it_behaves_like "a block that has plain text attributes", :title
    it_behaves_like "a block that has plain text emoji assignment", :title
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:alt_text) }
    it { is_expected.to validate_length_of(:alt_text).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:image_url).allow_nil }
    it { is_expected.to validate_length_of(:image_url).is_at_most(3000) }
    it { is_expected.to allow_value("http://example.com/").for(:image_url) }
    it { is_expected.to allow_value("https://example.com/").for(:image_url) }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:image_url).with_message("is not a valid URI") }
    it { is_expected.not_to allow_value("invalid_url").for(:image_url).with_message("is not a valid URI") }
    it { is_expected.to validate_presence_of(:title).allow_nil }

    it "validates that one (and only one) of url or slack_file is present" do
      image.image_url = nil
      image.slack_file = nil

      expect(image).not_to be_valid
      expect(image.errors[:base]).to include("must have either a slack_file or image_url but not both")

      image.image_url = "https://example.com"
      image.slack_file = BlockKit::Composition::SlackFile.new(id: "F12345678")

      expect(image).not_to be_valid
      expect(image.errors[:base]).to include("must have either a slack_file or image_url but not both")
    end
  end
end
