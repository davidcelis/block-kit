# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Context, type: :model do
  subject(:block) { described_class.new(attributes) }
  let(:attributes) do
    {
      elements: [
        BlockKit::Composition::PlainText.new(text: "Hello", emoji: false),
        BlockKit::Elements::Image.new(image_url: "https://example.com/image.png", alt_text: "An image"),
        BlockKit::Composition::Mrkdwn.new(text: "This is a text element", verbatim: true)
      ]
    }
  end

  describe "#image" do
    let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png"} }
    subject { block.image(**args) }

    it "appends an image element" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(subject).to eq(block)

      expect(block.elements.last).to be_a(BlockKit::Elements::Image)
      expect(block.elements.last.alt_text).to eq("A beautiful image")
      expect(block.elements.last.image_url).to eq("https://example.com/image.png")
    end

    context "with slack_file" do
      let(:args) { {alt_text: "A beautiful image", slack_file: BlockKit::Composition::SlackFile.new} }

      it "passes args to the image" do
        expect { subject }.to change { block.elements.size }.by(1)

        expect(block.elements.last.alt_text).to eq("A beautiful image")
        expect(block.elements.last.slack_file).to eq(args[:slack_file])
        expect(block.elements.last.image_url).to be_nil
      end
    end

    context "with both image_url and slack_file" do
      let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png", slack_file: BlockKit::Composition::SlackFile.new} }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Must provide either image_url or slack_file, but not both.")
      end
    end

    context "with neither image_url nor slack_file" do
      let(:args) { {alt_text: "A beautiful image"} }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "Must provide either image_url or slack_file, but not both.")
      end
    end
  end

  describe "#mrkdwn" do
    let(:args) { {text: "This is a text element"} }
    subject { block.mrkdwn(**args) }

    it "appends a mrkdwn element" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(subject).to eq(block)

      expect(block.elements.last).to be_a(BlockKit::Composition::Mrkdwn)
      expect(block.elements.last.text).to eq("This is a text element")
    end

    context "with optional args" do
      let(:args) { super().merge(verbatim: true) }

      it "passes args to the mrkdwn" do
        expect { subject }.to change { block.elements.size }.by(1)

        expect(block.elements.last.verbatim).to eq(true)
      end
    end
  end

  describe "#plain_text" do
    let(:args) { {text: "Hello"} }
    subject { block.plain_text(**args) }

    it "appends a plain_text element" do
      expect { subject }.to change { block.elements.size }.by(1)
      expect(subject).to eq(block)

      expect(block.elements.last).to be_a(BlockKit::Composition::PlainText)
      expect(block.elements.last.text).to eq("Hello")
    end

    context "with optional args" do
      let(:args) { super().merge(emoji: true) }

      it "passes args to the plain_text" do
        expect { subject }.to change { block.elements.size }.by(1)

        expect(block.elements.last.emoji).to eq(true)
      end
    end
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(block.as_json).to eq({
        type: described_class.type.to_s,
        elements: [
          {type: "plain_text", text: "Hello", emoji: false},
          {type: "image", image_url: "https://example.com/image.png", alt_text: "An image"},
          {type: "mrkdwn", text: "This is a text element", verbatim: true}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:elements).with_type(:array).containing(:block_kit_image, :block_kit_mrkdwn, :block_kit_plain_text) }

    it_behaves_like "a block with a block_id"

    it "does not allow unsupported elements" do
      expect {
        block.elements << BlockKit::Composition::Option.new
      }.not_to change {
        block.elements.size
      }
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:elements) }

    it "validates elements" do
      block.elements[1].image_url = ""

      expect(block).not_to be_valid
      expect(block.errors["elements[1]"]).to include("is invalid: image_url can't be blank")
    end
  end
end
