# frozen_string_literal: true

RSpec.describe BlockKit do
  it "has a version number" do
    expect(BlockKit::VERSION).not_to be nil
  end

  it "has a DSL for building blocks" do
    blocks = BlockKit.blocks do |blocks|
      blocks.header(text: "Hello, world!")
      blocks.divider
      blocks.section(text: "Some section text")
    end

    expect(blocks).to be_a(BlockKit::Blocks)
    expect(blocks.blocks.length).to eq(3)
    expect(blocks.blocks[0]).to be_a(BlockKit::Layout::Header).and(have_attributes(text: BlockKit::Composition::PlainText.new(text: "Hello, world!")))
    expect(blocks.blocks[1]).to be_a(BlockKit::Layout::Divider)
    expect(blocks.blocks[2]).to be_a(BlockKit::Layout::Section).and(have_attributes(text: BlockKit::Composition::Mrkdwn.new(text: "Some section text")))
  end

  it "has a DSL for building a home surface" do
    home = BlockKit.home do |home|
      home.header(text: "Hello, world!")
      home.divider
      home.section(text: "Some section text")
    end

    expect(home).to be_a(BlockKit::Surfaces::Home)
    expect(home.blocks.length).to eq(3)
    expect(home.blocks[0]).to be_a(BlockKit::Layout::Header).and(have_attributes(text: BlockKit::Composition::PlainText.new(text: "Hello, world!")))
    expect(home.blocks[1]).to be_a(BlockKit::Layout::Divider)
    expect(home.blocks[2]).to be_a(BlockKit::Layout::Section).and(have_attributes(text: BlockKit::Composition::Mrkdwn.new(text: "Some section text")))
  end

  it "has a DSL for building a modal surface" do
    modal = BlockKit.modal(title: "Hello, world!") do |modal|
      modal.header(text: "Hello, world!")
      modal.divider
      modal.section(text: "Some section text")
    end

    expect(modal).to be_a(BlockKit::Surfaces::Modal)
    expect(modal.title).to eq(BlockKit::Composition::PlainText.new(text: "Hello, world!"))
    expect(modal.blocks.length).to eq(3)
    expect(modal.blocks[0]).to be_a(BlockKit::Layout::Header).and(have_attributes(text: BlockKit::Composition::PlainText.new(text: "Hello, world!")))
    expect(modal.blocks[1]).to be_a(BlockKit::Layout::Divider)
    expect(modal.blocks[2]).to be_a(BlockKit::Layout::Section).and(have_attributes(text: BlockKit::Composition::Mrkdwn.new(text: "Some section text")))
  end

  it "has a DSL for building a message surface" do
    message = BlockKit.message(text: "Hello, world!") do |message|
      message.header(text: "Hello, world!")
      message.divider
      message.section(text: "Some section text")
    end

    expect(message).to be_a(BlockKit::Surfaces::Message)
    expect(message.text).to eq("Hello, world!")
    expect(message.blocks.length).to eq(3)
    expect(message.blocks[0]).to be_a(BlockKit::Layout::Header).and(have_attributes(text: BlockKit::Composition::PlainText.new(text: "Hello, world!")))
    expect(message.blocks[1]).to be_a(BlockKit::Layout::Divider)
    expect(message.blocks[2]).to be_a(BlockKit::Layout::Section).and(have_attributes(text: BlockKit::Composition::Mrkdwn.new(text: "Some section text")))
  end
end
