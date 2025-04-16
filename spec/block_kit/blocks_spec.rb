# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Blocks do
  subject(:blocks) { described_class.new }

  describe "#initialize" do
    it "initializes with an empty Typed array supporting all Layout blocks" do
      expect(blocks.blocks).to be_a(BlockKit::TypedArray)
      expect(blocks.blocks).to be_empty
      expect(blocks.blocks.item_type).to be_a(BlockKit::Types::Blocks)
      expect(blocks.blocks.item_type.block_classes).to match_array(BlockKit::Layout.all)
    end

    it "allows specifying supported blocks" do
      blocks = described_class.new(allow: [BlockKit::Layout::Actions])

      expect(blocks.blocks.item_type.block_classes).to match_array([BlockKit::Layout::Actions])
    end

    it "yields self" do
      described_class.new do |blocks|
        expect(blocks).to be_a(described_class)
      end
    end
  end

  describe "#append" do
    it "appends a block to the blocks array and returns itself" do
      block = BlockKit::Layout::Actions.new

      result = blocks.append(block)
      expect(result).to eq(blocks)
      expect(blocks.size).to eq(1)
      expect(blocks.last).to eq(block)
    end
  end

  describe "#actions" do
    let(:args) { {} }
    subject { blocks.actions(**args) }

    it "appends an actions block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)
      expect(blocks.last).to be_a(BlockKit::Layout::Actions)
    end

    it "yields the block" do
      expect { |b| blocks.actions(&b) }.to yield_with_args(BlockKit::Layout::Actions)
    end

    context "with optional args" do
      let(:args) do
        super().merge(
          elements: [BlockKit::Elements::Button.new(text: "Click me")],
          block_id: "block_id"
        )
      end

      it "passes args to the actions block" do
        expect { subject }.to change { blocks.size }.by(1)
        expect(blocks.last.elements).to eq(args[:elements])
        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#context" do
    let(:args) { {} }
    subject { blocks.context(**args) }

    it "appends a context block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)
      expect(blocks.last).to be_a(BlockKit::Layout::Context)
    end

    it "yields the block" do
      expect { |b| blocks.context(&b) }.to yield_with_args(BlockKit::Layout::Context)
    end

    context "with optional args" do
      let(:args) do
        super().merge(
          elements: [BlockKit::Elements::Image.new(image_url: "https://example.com/image.png", alt_text: "An image")],
          block_id: "block_id"
        )
      end

      it "passes args to the actions block" do
        expect { subject }.to change { blocks.size }.by(1)
        expect(blocks.last.elements).to eq(args[:elements])
        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#divider" do
    let(:args) { {} }
    subject { blocks.divider(**args) }

    it "appends a divider block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)

      expect(blocks.last).to be_a(BlockKit::Layout::Divider)
    end

    context "with optional args" do
      let(:args) { super().merge(block_id: "block_id") }

      it "passes args to the divider" do
        expect { subject }.to change { blocks.size }.by(1)
        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#header" do
    let(:args) { {text: "Hello, world!"} }
    subject { blocks.header(**args) }

    it "appends a header block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)

      expect(blocks.last).to be_a(BlockKit::Layout::Header)
      expect(blocks.last.text.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(emoji: false, block_id: "block_id") }

      it "passes args to the header" do
        expect { subject }.to change { blocks.size }.by(1)

        expect(blocks.last.text.emoji).to be false
        expect(blocks.last.block_id).to eq("block_id")
      end
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

  describe "#input" do
    let(:args) { {} }
    subject { blocks.input(**args) }

    it "appends an input block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)

      expect(blocks.last).to be_a(BlockKit::Layout::Input)
    end

    it "yields the block" do
      expect { |b| blocks.input(**args, &b) }.to yield_with_args(BlockKit::Layout::Input)
    end

    context "with optional args" do
      let(:args) do
        super().merge(
          label: "An input",
          hint: "Enter something good",
          element: BlockKit::Elements::PlainTextInput.new,
          optional: false,
          dispatch_action: true,
          emoji: false,
          block_id: "block_id"
        )
      end

      it "passes args to the input block" do
        expect { subject }.to change { blocks.size }.by(1)

        expect(blocks.last.label.emoji).to be false
        expect(blocks.last.label.text).to eq("An input")
        expect(blocks.last.hint.text).to eq("Enter something good")
        expect(blocks.last.hint.emoji).to be false
        expect(blocks.last.element).to eq(args[:element])
        expect(blocks.last).not_to be_optional
        expect(blocks.last).to be_dispatch_action
        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#markdown" do
    let(:args) { {text: "Hello, world!"} }
    subject { blocks.markdown(**args) }

    it "appends a markdown block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)

      expect(blocks.last).to be_a(BlockKit::Layout::Markdown)
      expect(blocks.last.text).to eq("Hello, world!")
    end

    context "with optional args" do
      let(:args) { super().merge(block_id: "block_id") }

      it "passes args to the markdown block" do
        expect { subject }.to change { blocks.size }.by(1)

        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#rich_text" do
    let(:args) { {} }
    subject { blocks.rich_text(**args) }

    it "appends an rich_text block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)
      expect(blocks.last).to be_a(BlockKit::Layout::RichText)
    end

    it "yields the block" do
      expect { |b| blocks.rich_text(&b) }.to yield_with_args(BlockKit::Layout::RichText)
    end

    context "with optional args" do
      let(:args) do
        super().merge(
          elements: [BlockKit::Layout::RichText::Section.new],
          block_id: "block_id"
        )
      end

      it "passes args to the rich_text block" do
        expect { subject }.to change { blocks.size }.by(1)
        expect(blocks.last.elements).to eq(args[:elements])
        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#section" do
    let(:args) { {} }
    subject { blocks.section(**args) }

    it "appends an section block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)
      expect(blocks.last).to be_a(BlockKit::Layout::Section)
    end

    it "yields the block" do
      expect { |b| blocks.section(&b) }.to yield_with_args(BlockKit::Layout::Section)
    end

    context "with optional args" do
      let(:args) do
        super().merge(
          text: "Hello, world!",
          fields: [BlockKit::Composition::PlainText.new(text: "A field")],
          accessory: BlockKit::Elements::Image.new(image_url: "https://example.com/image.png", alt_text: "An image"),
          expand: true,
          block_id: "block_id"
        )
      end

      it "passes args to the section block" do
        expect { subject }.to change { blocks.size }.by(1)
        expect(blocks.last.text.text).to eq("Hello, world!")
        expect(blocks.last.fields).to eq(args[:fields])
        expect(blocks.last.accessory).to eq(args[:accessory])
        expect(blocks.last).to be_expand
        expect(blocks.last.block_id).to eq("block_id")
      end
    end
  end

  describe "#video" do
    let(:args) do
      {
        alt_text: "The story of a wealthy family who lost everything and the one son who had no choice but to keep them all together.",
        title: "Arrested Development",
        thumbnail_url: "https://i.ytimg.com/vi/Nl_Qyk9DSUw/hqdefault.jpg",
        video_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw"
      }
    end
    subject { blocks.video(**args) }

    it "appends a video block" do
      expect { subject }.to change { blocks.size }.by(1)
      expect(subject).to eq(blocks)

      expect(blocks.last).to be_a(BlockKit::Layout::Video)
      expect(blocks.last.alt_text).to eq(args[:alt_text])
      expect(blocks.last.title.text).to eq(args[:title])
      expect(blocks.last.thumbnail_url).to eq(args[:thumbnail_url])
      expect(blocks.last.video_url).to eq(args[:video_url])
    end

    context "with optional args" do
      let(:args) do
        super().merge(
          author_name: "Mitchell Hurwitz",
          description: "It's one banana, Michael. What could it cost? Ten dollars?",
          provider_icon_url: "https://www.youtube.com/favicon.ico",
          provider_name: "YouTube",
          title_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw",
          emoji: false,
          block_id: "block_id"
        )
      end

      it "passes args to the video" do
        expect { subject }.to change { blocks.size }.by(1)

        expect(blocks.last.author_name).to eq(args[:author_name])
        expect(blocks.last.description.text).to eq(args[:description])
        expect(blocks.last.description.emoji).to be false
        expect(blocks.last.provider_icon_url).to eq(args[:provider_icon_url])
        expect(blocks.last.provider_name).to eq(args[:provider_name])
        expect(blocks.last.title.text).to eq(args[:title])
        expect(blocks.last.title.emoji).to be false
        expect(blocks.last.title_url).to eq(args[:title_url])
        expect(blocks.last.block_id).to eq("block_id")
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
