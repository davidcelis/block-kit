# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Surfaces::Home, type: :model do
  let(:attributes) { {} }
  subject(:home) { described_class.new(**attributes) }

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

      result = home.append(block)
      expect(result).to eq(home)
      expect(home.blocks.size).to eq(1)
      expect(home.blocks.last).to eq(block)
    end
  end

  describe "#image" do
    let(:args) { {alt_text: "A beautiful image", image_url: "https://example.com/image.png"} }
    subject { home.image(**args) }

    it "appends a image block" do
      expect { subject }.to change { home.blocks.size }.by(1)
      expect(subject).to eq(home)

      expect(home.blocks.last).to be_a(BlockKit::Layout::Image)
      expect(home.blocks.last.alt_text).to eq("A beautiful image")
      expect(home.blocks.last.image_url).to eq("https://example.com/image.png")
    end

    context "with optional args" do
      let(:args) { super().merge(title: "My Image", emoji: false, block_id: "block_id") }

      it "passes args to the image" do
        expect { subject }.to change { home.blocks.size }.by(1)

        expect(home.blocks.last.title.text).to eq("My Image")
        expect(home.blocks.last.title.emoji).to be false
        expect(home.blocks.last.block_id).to eq("block_id")
      end
    end

    context "with slack_file" do
      let(:args) { {alt_text: "A beautiful image", slack_file: BlockKit::Composition::SlackFile.new} }

      it "passes args to the image" do
        expect { subject }.to change { home.blocks.size }.by(1)

        expect(home.blocks.last.alt_text).to eq("A beautiful image")
        expect(home.blocks.last.slack_file).to eq(args[:slack_file])
        expect(home.blocks.last.image_url).to be_nil
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
      {
        private_metadata: "Some metadata",
        callback_id: "callback_id",
        external_id: "external_id"
      }
    end

    it "serializes as JSON" do
      home.header(text: "Hello, world!")
      home.divider

      expect(home.as_json).to eq({
        type: described_class.type.to_s,
        private_metadata: "Some metadata",
        callback_id: "callback_id",
        external_id: "external_id",
        blocks: [
          {type: "header", text: {type: "plain_text", text: "Hello, world!"}},
          {type: "divider"}
        ]
      })
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:private_metadata).with_type(:string) }
    it { is_expected.to have_attribute(:callback_id).with_type(:string) }
    it { is_expected.to have_attribute(:external_id).with_type(:string) }

    it do
      is_expected.to have_attribute(:blocks).with_type(:array).containing(
        :block_kit_actions,
        :block_kit_context,
        :block_kit_divider,
        :block_kit_header,
        :block_kit_image,
        :block_kit_input,
        :block_kit_rich_text,
        :block_kit_section,
        :block_kit_video
      ).with_default_value([])
    end
  end

  context "validates" do
    it { is_expected.to validate_length_of(:private_metadata).is_at_most(3000).allow_nil }
    it { is_expected.to validate_length_of(:callback_id).is_at_most(255).allow_nil }
    it { is_expected.to validate_length_of(:external_id).is_at_most(255).allow_nil }

    it "validates a maximum of 100 blocks" do
      100.times { home.blocks << BlockKit::Layout::Section.new(text: "Some text") }
      expect(home).to be_valid

      home.blocks << BlockKit::Layout::Section.new(text: "Some text")
      expect(home).not_to be_valid
      expect(home.errors[:blocks]).to include("is too long (maximum is 100 blocks)")
    end

    it "validates associated blocks" do
      home.header(text: "Some very long text" * BlockKit::Layout::Header::MAX_LENGTH)
      home.divider
      home.section(text: "More long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

      expect(home).not_to be_valid
      expect(home.errors[:blocks]).to include("is invalid")
      expect(home.errors["blocks[0]"]).to include("is invalid: text is too long (maximum is #{BlockKit::Layout::Header::MAX_LENGTH} characters)")
      expect(home.errors["blocks[2]"]).to include("is invalid: text is too long (maximum is #{BlockKit::Layout::Section::MAX_TEXT_LENGTH} characters)")
    end

    it "validates that no unsupported elements are present" do
      home.actions do |actions|
        actions.static_select
        actions.datetime_picker
      end

      home.input(label: "Email", element: BlockKit::Elements::EmailTextInput.new)
      home.input(label: "Multi-select", element: BlockKit::Elements::MultiStaticSelect.new)

      home.actions do |actions|
        actions.button(text: "A button")
        actions.workflow_button(text: "A workflow")
      end

      home.input(label: "Attachments", element: BlockKit::Elements::FileInput.new)
      home.input(label: "Options", element: BlockKit::Elements::RadioButtons.new)

      home.section(text: "Some text", accessory: BlockKit::Elements::WorkflowButton.new)

      home.input(label: "Number", element: BlockKit::Elements::NumberInput.new)
      home.input(label: "WYSIWYG", element: BlockKit::Elements::RichTextInput.new)
      home.input(label: "Plain text", element: BlockKit::Elements::PlainTextInput.new)
      home.input(label: "URL", element: BlockKit::Elements::URLTextInput.new)

      home.validate

      expect(home.errors[:blocks]).to include("contains unsupported elements")
      expect(home.errors["blocks[0].elements[0]"]).to be_empty
      expect(home.errors["blocks[0].elements[1]"]).to include("is invalid: datetimepicker is not a supported element for this surface")
      expect(home.errors["blocks[1].element"]).to include("is invalid: email_text_input is not a supported element for this surface")
      expect(home.errors["blocks[2].element"]).to be_empty
      expect(home.errors["blocks[3].elements[0]"]).to be_empty
      expect(home.errors["blocks[3].elements[1]"]).to include("is invalid: workflow_button is not a supported element for this surface")
      expect(home.errors["blocks[4].element"]).to include("is invalid: file_input is not a supported element for this surface")
      expect(home.errors["blocks[5].element"]).to be_empty
      expect(home.errors["blocks[6].accessory"]).to include("is invalid: workflow_button is not a supported element for this surface")
      expect(home.errors["blocks[7].element"]).to include("is invalid: number_input is not a supported element for this surface")
      expect(home.errors["blocks[8].element"]).to be_empty
      expect(home.errors["blocks[9].element"]).to be_empty
      expect(home.errors["blocks[10].element"]).to include("is invalid: url_text_input is not a supported element for this surface")
    end

    it "validates that only one nested block can focus on load" do
      home.section(text: "Some text", accessory: BlockKit::Elements::ExternalSelect.new(focus_on_load: true))
      expect(home).to be_valid

      home.input(label: "Some label", element: BlockKit::Elements::PlainTextInput.new(focus_on_load: true))
      home.actions do |actions|
        actions.rich_text_input(focus_on_load: true)
        actions.button(text: "A button", value: "button_value")
        actions.checkboxes(options: [{text: "Option 1", value: "value_1"}], focus_on_load: true)
      end

      expect(home).not_to be_valid
      expect(home.errors[:blocks]).to include("can't have more than one element with focus_on_load set to true")
      expect(home.errors["blocks[0].accessory"]).to include("is invalid: can't set focus_on_load when other elements have set focus_on_load")
      expect(home.errors["blocks[1].element"]).to include("is invalid: can't set focus_on_load when other elements have set focus_on_load")
      expect(home.errors["blocks[2].elements[0]"]).to include("is invalid: can't set focus_on_load when other elements have set focus_on_load")
      expect(home.errors["blocks[2].elements[2]"]).to include("is invalid: can't set focus_on_load when other elements have set focus_on_load")
    end
  end

  it "fixes individually-contained blocks" do
    home.header(text: "Some very long text" * BlockKit::Layout::Header::MAX_LENGTH)
    home.divider
    home.section(text: "More long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

    expect(home.fix_validation_errors).to be true

    expect(home.blocks.first.text.length).to be <= BlockKit::Layout::Header::MAX_LENGTH
    expect(home.blocks.last.text.length).to be <= BlockKit::Layout::Section::MAX_TEXT_LENGTH
  end

  it "fixes unsupported elements by removing them" do
    home.actions do |actions|
      actions.static_select
      actions.datetime_picker
    end

    home.input(label: "Email", element: BlockKit::Elements::EmailTextInput.new)
    home.input(label: "Multi-select", element: BlockKit::Elements::MultiStaticSelect.new)

    home.actions do |actions|
      actions.button(text: "A button")
      actions.workflow_button(text: "A workflow")
    end

    home.input(label: "Attachments", element: BlockKit::Elements::FileInput.new)
    home.input(label: "Options", element: BlockKit::Elements::RadioButtons.new)

    home.section(text: "Some text", accessory: BlockKit::Elements::WorkflowButton.new)

    home.input(label: "Number", element: BlockKit::Elements::NumberInput.new)
    home.input(label: "WYSIWYG", element: BlockKit::Elements::RichTextInput.new)
    home.input(label: "Plain text", element: BlockKit::Elements::PlainTextInput.new)
    home.input(label: "URL", element: BlockKit::Elements::URLTextInput.new)

    home.fix_validation_errors(dangerous: true)

    expect(home.blocks[0].elements.length).to eq(1)
    expect(home.blocks[0].elements.first).to be_a(BlockKit::Elements::StaticSelect)
    expect(home.blocks[1].element).to be_nil
    expect(home.blocks[2].element).to be_present
    expect(home.blocks[3].elements.length).to eq(1)
    expect(home.blocks[3].elements.first).to be_a(BlockKit::Elements::Button)
    expect(home.blocks[4].element).to be_nil
    expect(home.blocks[5].element).to be_present
    expect(home.blocks[6].accessory).to be_nil
    expect(home.blocks[7].element).to be_nil
    expect(home.blocks[8].element).to be_present
    expect(home.blocks[9].element).to be_present
    expect(home.blocks[10].element).to be_nil
  end

  it "fixes nested focusable blocks by removing focus_on_load" do
    external_select = BlockKit::Elements::ExternalSelect.new(focus_on_load: true)
    plain_text_input = BlockKit::Elements::PlainTextInput.new(focus_on_load: true)
    rich_text_input = BlockKit::Elements::RichTextInput.new(focus_on_load: true)
    button = BlockKit::Elements::Button.new(text: "A button", value: "button_value")
    checkboxes = BlockKit::Elements::Checkboxes.new(options: [{text: "Option 1", value: "value_1"}], focus_on_load: true)

    home.section(text: "Some text", accessory: external_select)
    home.input(label: "Some label", element: plain_text_input)
    home.actions(elements: [rich_text_input, button, checkboxes])

    expect {
      home.fix_validation_errors
    }.to change {
      external_select.focus_on_load
    }.from(true).to(false).and change {
      plain_text_input.focus_on_load
    }.from(true).to(false).and change {
      rich_text_input.focus_on_load
    }.from(true).to(false).and change {
      checkboxes.focus_on_load
    }.from(true).to(false)
  end

  it "can raise unfixed validation errors" do
    home.header(text: "")
    home.divider
    home.section(text: "Long text" * BlockKit::Layout::Section::MAX_TEXT_LENGTH)

    expect { home.fix_validation_errors! }.to raise_error(ActiveModel::ValidationError)

    expect(home.blocks.last.text.length).to be <= BlockKit::Layout::Section::MAX_TEXT_LENGTH
  end

  it "truncates the list of blocks" do
    (described_class::MAX_BLOCKS + 1).times { |i| home.section(text: "Section #{i + 1}") }

    expect { home.fix_validation_errors }.not_to change { home.blocks.length }

    expect {
      home.fix_validation_errors(dangerous: true)
    }.to change {
      home.blocks.length
    }.to(described_class::MAX_BLOCKS)

    expect(home.blocks.last.text.text).to eq("Section #{described_class::MAX_BLOCKS}")
  end
end
