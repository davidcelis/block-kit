# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Blocks, type: :model do
  subject(:blocks) { described_class.new }

  it_behaves_like "a class that yields self on initialize"

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :actions,
    type: BlockKit::Layout::Actions,
    actual_fields: {elements: [{type: "button", text: "A button", value: "button_value"}, block_id: "block_id"]},
    expected_fields: {
      elements: [BlockKit::Elements::Button.new(text: "A button", value: "button_value")],
      block_id: "block_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :context,
    type: BlockKit::Layout::Context,
    actual_fields: {elements: [{type: "plain_text", text: "Some text"}, block_id: "block_id"]},
    expected_fields: {
      elements: [BlockKit::Composition::PlainText.new(text: "Some text")],
      block_id: "block_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :divider,
    type: BlockKit::Layout::Divider,
    actual_fields: {block_id: "block_id"},
    expected_fields: {block_id: "block_id"},
    yields: false

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :file,
    type: BlockKit::Layout::File,
    required_fields: [:external_id],
    actual_fields: {external_id: "external_id", block_id: "block_id"},
    expected_fields: {external_id: "external_id", block_id: "block_id"},
    yields: false

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :header,
    type: BlockKit::Layout::Header,
    actual_fields: {text: "Header text", emoji: true, block_id: "block_id"},
    expected_fields: {
      text: BlockKit::Composition::PlainText.new(text: "Header text", emoji: true),
      block_id: "block_id"
    },
    yields: false

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :input,
    type: BlockKit::Layout::Input,
    actual_fields: {
      label: "Input label",
      element: BlockKit::Elements::PlainTextInput.new,
      dispatch_action: false,
      hint: "Input hint",
      optional: true,
      emoji: false,
      block_id: "block_id"
    },
    expected_fields: {
      label: BlockKit::Composition::PlainText.new(text: "Input label", emoji: false),
      element: BlockKit::Elements::PlainTextInput.new,
      dispatch_action: false,
      hint: BlockKit::Composition::PlainText.new(text: "Input hint", emoji: false),
      optional: true,
      block_id: "block_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :markdown,
    type: BlockKit::Layout::Markdown,
    required_fields: [:text],
    actual_fields: {text: "Some **bold** text!", block_id: "block_id"},
    expected_fields: {text: "Some **bold** text!", block_id: "block_id"},
    yields: false

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :rich_text,
    type: BlockKit::Layout::RichText,
    actual_fields: {elements: [{type: "rich_text_section", elements: [{type: "text", text: "Some rich text"}]}], block_id: "block_id"},
    expected_fields: {
      elements: [BlockKit::Layout::RichText::Section.new(elements: [{type: "text", text: "Some rich text"}])],
      block_id: "block_id"
    }
  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :section,
    type: BlockKit::Layout::Section,
    actual_fields: {
      text: "Some section text",
      fields: [BlockKit::Composition::PlainText.new(text: "Field 1"), BlockKit::Composition::PlainText.new(text: "Field 2")],
      accessory: BlockKit::Elements::Image.new(image_url: "https://example.com/image.png", alt_text: "An image"),
      expand: false,
      block_id: "block_id"
    },
    expected_fields: {
      text: BlockKit::Composition::Mrkdwn.new(text: "Some section text"),
      fields: [BlockKit::Composition::PlainText.new(text: "Field 1"), BlockKit::Composition::PlainText.new(text: "Field 2")],
      accessory: BlockKit::Elements::Image.new(image_url: "https://example.com/image.png", alt_text: "An image"),
      expand: false,
      block_id: "block_id"
    }

  it_behaves_like "a block that has a DSL method",
    attribute: :blocks,
    as: :video,
    type: BlockKit::Layout::Video,
    required_fields: [:alt_text, :title, :thumbnail_url, :video_url],
    actual_fields: {
      alt_text: "A detailed description of the video",
      title: "Video Title",
      thumbnail_url: "https://example.com/thumbnail.jpg",
      video_url: "https://example.com/video.mp4",
      author_name: "Author Name",
      description: "A brief description of the video",
      provider_icon_url: "https://example.com/icon.png",
      provider_name: "Provider Name",
      title_url: "https://example.com/title",
      emoji: true,
      block_id: "block_id"
    },
    expected_fields: {
      alt_text: "A detailed description of the video",
      title: BlockKit::Composition::PlainText.new(text: "Video Title", emoji: true),
      thumbnail_url: "https://example.com/thumbnail.jpg",
      video_url: "https://example.com/video.mp4",
      author_name: "Author Name",
      description: BlockKit::Composition::PlainText.new(text: "A brief description of the video", emoji: true),
      provider_icon_url: "https://example.com/icon.png",
      provider_name: "Provider Name",
      title_url: "https://example.com/title",
      block_id: "block_id"
    },
    yields: false

  describe "#append" do
    it "appends a block to the blocks array and returns itself" do
      block = BlockKit::Layout::Actions.new

      result = blocks.append(block)
      expect(result).to eq(blocks)
      expect(blocks.size).to eq(1)
      expect(blocks.last).to eq(block)
    end
  end

  describe "#image" do
    let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png"} }
    subject { blocks.image(**args) }

    it "appends a image block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)

      expect(blocks.last).to be_a(BlockKit::Layout::Image)
      expect(blocks.last.alt_text).to eq("A beautiful image")
      expect(blocks.last.image_url).to eq("https://example.com/image.png")
    end

    context "with optional args" do
      let(:args) { super().merge(title: "My Image", emoji: false, block_id: "block_id") }

      it "passes args to the image" do
        expect { subject }.to change { blocks.size }.by(1)

        expect(blocks.last.title.text).to eq("My Image")
        expect(blocks.last.title.emoji).to be false
        expect(blocks.last.block_id).to eq("block_id")
      end
    end

    context "with slack_file" do
      let(:args) { {alt_text: "A beautiful image", slack_file: BlockKit::Composition::SlackFile.new} }

      it "passes args to the image" do
        expect { subject }.to change { blocks.size }.by(1)

        expect(blocks.last.alt_text).to eq("A beautiful image")
        expect(blocks.last.slack_file).to eq(args[:slack_file])
        expect(blocks.last.image_url).to be_nil
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

  describe "#as_json" do
    it "serializes the list of blocks to JSON" do
      blocks.header(text: "Hello, world!")
      blocks.divider

      expect(blocks.as_json).to eq([
        {
          type: "header",
          text: {type: "plain_text", text: "Hello, world!"}
        },
        {type: "divider"}
      ])
    end
  end

  context "attributes" do
    it do
      is_expected.to have_attribute(:blocks).with_type(:array).containing(
        :block_kit_actions,
        :block_kit_context,
        :block_kit_divider,
        :block_kit_file,
        :block_kit_header,
        :block_kit_image,
        :block_kit_input,
        :block_kit_markdown,
        :block_kit_rich_text,
        :block_kit_section,
        :block_kit_video
      )
    end
  end

  context "validates" do
    it "validates associated blocks" do
      blocks.header(text: "Some very long text" * BlockKit::Layout::Header::MAX_LENGTH)
      blocks.divider
      blocks.section(text: "More long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

      expect(blocks).not_to be_valid
      expect(blocks.errors[:blocks]).to include("is invalid")
      expect(blocks.errors["blocks[0]"]).to include("is invalid: text is too long (maximum is #{BlockKit::Layout::Header::MAX_LENGTH} characters)")
      expect(blocks.errors["blocks[2]"]).to include("is invalid: text is too long (maximum is #{BlockKit::Layout::Section::MAX_TEXT_LENGTH} characters)")
    end
  end

  it "fixes individually-contained blocks" do
    blocks.header(text: "Some very long text" * BlockKit::Layout::Header::MAX_LENGTH)
    blocks.divider
    blocks.section(text: "More long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

    expect(blocks.fix_validation_errors).to be true

    expect(blocks.first.text.length).to be <= BlockKit::Layout::Header::MAX_LENGTH
    expect(blocks.last.text.length).to be <= BlockKit::Layout::Section::MAX_TEXT_LENGTH
  end

  it "can raise unfixed validation errors" do
    blocks.header(text: "")
    blocks.divider
    blocks.section(text: "Long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

    expect { blocks.fix_validation_errors! }.to raise_error(ActiveModel::ValidationError)

    expect(blocks.last.text.length).to be <= BlockKit::Layout::Section::MAX_TEXT_LENGTH
  end
end
