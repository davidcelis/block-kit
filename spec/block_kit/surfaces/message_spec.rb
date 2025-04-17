# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Surfaces::Message, type: :model do
  let(:attributes) { {text: "Hello, world!"} }
  subject(:message) { described_class.new(**attributes) }

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

      result = message.append(block)
      expect(result).to eq(message)
      expect(message.blocks.size).to eq(1)
      expect(message.blocks.last).to eq(block)
    end
  end

  describe "#image" do
    let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png"} }
    subject { message.image(**args) }

    it "appends a image block" do
      expect { subject }.to change { message.blocks.size }.by(1)
      expect(subject).to eq(message)

      expect(message.blocks.last).to be_a(BlockKit::Layout::Image)
      expect(message.blocks.last.alt_text).to eq("A beautiful image")
      expect(message.blocks.last.image_url).to eq("https://example.com/image.png")
    end

    context "with optional args" do
      let(:args) { super().merge(title: "My Image", emoji: false, block_id: "block_id") }

      it "passes args to the image" do
        expect { subject }.to change { message.blocks.size }.by(1)

        expect(message.blocks.last.title.text).to eq("My Image")
        expect(message.blocks.last.title.emoji).to be false
        expect(message.blocks.last.block_id).to eq("block_id")
      end
    end

    context "with slack_file" do
      let(:args) { {alt_text: "A beautiful image", slack_file: BlockKit::Composition::SlackFile.new} }

      it "passes args to the image" do
        expect { subject }.to change { message.blocks.size }.by(1)

        expect(message.blocks.last.alt_text).to eq("A beautiful image")
        expect(message.blocks.last.slack_file).to eq(args[:slack_file])
        expect(message.blocks.last.image_url).to be_nil
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
    let(:attributes) do
      super().merge(
        thread_ts: "123456789.12345",
        mrkdwn: false
      )
    end

    it "serializes as JSON" do
      message.header(text: "Hello, world!")
      message.divider

      expect(message.as_json).to eq({
        text: "Hello, world!",
        thread_ts: "123456789.12345",
        mrkdwn: false,
        blocks: [
          {type: "header", text: {type: "plain_text", text: "Hello, world!"}},
          {type: "divider"}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:string) }
    it { is_expected.to have_attribute(:thread_ts).with_type(:string) }
    it { is_expected.to have_attribute(:mrkdwn).with_type(:boolean) }

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
    it { is_expected.to validate_presence_of(:text) }

    it "validates a maximum of 50 blocks" do
      50.times { message.blocks << BlockKit::Layout::Section.new(text: "Some text") }
      expect(message).to be_valid

      message.blocks << BlockKit::Layout::Section.new(text: "Some text")
      expect(message).not_to be_valid
      expect(message.errors[:blocks]).to include("is too long (maximum is 50 blocks)")
    end

    it "validates associated blocks" do
      message.header(text: "Some very long text" * BlockKit::Layout::Header::MAX_LENGTH)
      message.divider
      message.section(text: "More long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

      expect(message).not_to be_valid
      expect(message.errors[:blocks]).to include("is invalid")
      expect(message.errors["blocks[0]"]).to include("is invalid: text is too long (maximum is #{BlockKit::Layout::Header::MAX_LENGTH} characters)")
      expect(message.errors["blocks[2]"]).to include("is invalid: text is too long (maximum is #{BlockKit::Layout::Section::MAX_TEXT_LENGTH} characters)")
    end

    it "validates that no unsupported elements are present" do
      message.input(label: "Email", element: BlockKit::Elements::EmailTextInput.new)
      message.input(label: "Select", element: BlockKit::Elements::StaticSelect.new)
      message.input(label: "Attachments", element: BlockKit::Elements::FileInput.new)
      message.input(label: "Options", element: BlockKit::Elements::RadioButtons.new)
      message.input(label: "Number", element: BlockKit::Elements::NumberInput.new)
      message.input(label: "WYSIWYG", element: BlockKit::Elements::RichTextInput.new)
      message.input(label: "Plain text", element: BlockKit::Elements::PlainTextInput.new)
      message.input(label: "URL", element: BlockKit::Elements::URLTextInput.new)

      message.validate

      expect(message.errors[:blocks]).to include("contains unsupported elements")
      expect(message.errors["blocks[0].element"]).to include("is invalid: email_text_input is not a supported element for this surface")
      expect(message.errors["blocks[1].element"]).to be_empty
      expect(message.errors["blocks[2].element"]).to include("is invalid: file_input is not a supported element for this surface")
      expect(message.errors["blocks[3].element"]).to be_empty
      expect(message.errors["blocks[4].element"]).to include("is invalid: number_input is not a supported element for this surface")
      expect(message.errors["blocks[5].element"]).to include("is invalid: rich_text_input is not a supported element for this surface")
      expect(message.errors["blocks[6].element"]).to be_empty
      expect(message.errors["blocks[7].element"]).to include("is invalid: url_text_input is not a supported element for this surface")
    end
  end

  it "fixes individually-contained blocks" do
    message.header(text: "Some very long text" * BlockKit::Layout::Header::MAX_LENGTH)
    message.divider
    message.section(text: "More long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

    expect(message.fix_validation_errors).to be true

    expect(message.blocks.first.text.length).to be <= BlockKit::Layout::Header::MAX_LENGTH
    expect(message.blocks.last.text.length).to be <= BlockKit::Layout::Section::MAX_TEXT_LENGTH
  end

  it "removes unsupported elements" do
    message.input(label: "Email", element: BlockKit::Elements::EmailTextInput.new)
    message.input(label: "Select", element: BlockKit::Elements::StaticSelect.new)
    message.input(label: "Attachments", element: BlockKit::Elements::FileInput.new)
    message.input(label: "Options", element: BlockKit::Elements::RadioButtons.new)
    message.input(label: "Number", element: BlockKit::Elements::NumberInput.new)
    message.input(label: "WYSIWYG", element: BlockKit::Elements::RichTextInput.new)
    message.input(label: "Plain text", element: BlockKit::Elements::PlainTextInput.new)
    message.input(label: "URL", element: BlockKit::Elements::URLTextInput.new)

    message.fix_validation_errors(dangerous: true)

    expect(message.blocks[0].element).to be_nil
    expect(message.blocks[1].element).to be_present
    expect(message.blocks[2].element).to be_nil
    expect(message.blocks[3].element).to be_present
    expect(message.blocks[4].element).to be_nil
    expect(message.blocks[5].element).to be_nil
    expect(message.blocks[6].element).to be_present
    expect(message.blocks[7].element).to be_nil
  end

  it "truncates the list of blocks" do
    (described_class::MAX_BLOCKS + 1).times { |i| message.section(text: "Section #{i + 1}") }

    expect { message.fix_validation_errors }.not_to change { message.blocks.length }

    expect {
      message.fix_validation_errors(dangerous: true)
    }.to change {
      message.blocks.length
    }.to(described_class::MAX_BLOCKS)

    expect(message.blocks.last.text.text).to eq("Section #{described_class::MAX_BLOCKS}")
  end

  it "can raise unfixed validation errors" do
    message.header(text: "")
    message.divider
    message.section(text: "Long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

    expect { message.fix_validation_errors! }.to raise_error(ActiveModel::ValidationError)

    expect(message.blocks.last.text.length).to be <= BlockKit::Layout::Section::MAX_TEXT_LENGTH
  end
end
