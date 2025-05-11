# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Base do
  it "raises NotImplementedError when instantiated directly" do
    expect { described_class.new }.to raise_error(NotImplementedError, "#{described_class} is an abstract class and can't be instantiated.")
  end

  block_class = Class.new(BlockKit::Base) do
    def self.name = "TestBlock"
    self.type = :block

    attribute :text, :string
    validates :text, length: {maximum: 25}
    fixes :text, truncate: {maximum: 25}

    attribute :items, BlockKit::Types::Array.of(:string)
    validates :items, presence: true, length: {maximum: 5, message: "is too long (maximum is 5 items)"}, allow_nil: true
    fixes :items, truncate: {maximum: 5, dangerous: true}, null_value: {error_types: [:blank]}

    def as_json(*)
      super().merge(text: text, items: items).compact
    end
  end

  it_behaves_like "a class that yields self on initialize" do
    let(:described_class) { block_class }
  end

  context "fixers" do
    it "allows fixing validation errors" do
      block = block_class.new(text: "This is a very long text that exceeds the maximum length", items: [])
      expect(block).not_to be_valid
      expect(block.errors[:text]).to include("is too long (maximum is 25 characters)")
      expect(block.errors[:items]).to include("can't be blank")

      block.fix_validation_errors

      expect(block).to be_valid
      expect(block.text).to eq("This is a very long te...")
      expect(block.items).to be_nil
    end

    it "does not fix dangerous validation errors unless specified" do
      block = block_class.new(text: "This is a very long text that exceeds the maximum length", items: ["1", "2", "3", "4", "5", "6", "7"])
      expect(block).not_to be_valid
      expect(block.errors[:text]).to include("is too long (maximum is 25 characters)")
      expect(block.errors[:items]).to include("is too long (maximum is 5 items)")

      block.fix_validation_errors

      expect(block).not_to be_valid
      expect(block.text).to eq("This is a very long te...")
      expect(block.items).to eq(["1", "2", "3", "4", "5", "6", "7"])

      block.fix_validation_errors(dangerous: true)
      expect(block).to be_valid
      expect(block.text).to eq("This is a very long te...")
      expect(block.items).to eq(["1", "2", "3", "4", "5"])
    end

    context "with autofix_on_validation enabled" do
      around do |example|
        BlockKit.config.autofix_on_validation = true
        example.run
        BlockKit.config.autofix_on_validation = false
      end

      it "fixes automatically" do
        block = block_class.new(text: "This is a very long text that exceeds the maximum length", items: [])
        expect(block).to be_valid
        expect(block.text).to eq("This is a very long te...")
        expect(block.items).to be_nil
      end
    end

    context "with autofix_on_render enabled" do
      around do |example|
        BlockKit.config.autofix_on_render = true
        example.run
        BlockKit.config.autofix_on_render = false
      end

      it "allows fixing validation errors when rendering as JSON" do
        block = block_class.new(text: "This is a very long text that exceeds the maximum length", items: [])
        expect(block).not_to be_valid

        json = block.as_json
        expect(json[:text]).to eq("This is a very long te...")
        expect(json[:items]).to be_nil

        expect(block).to be_valid
        expect(block.text).to eq(json[:text])
        expect(block.items).to be_nil
      end
    end

    context "with autofix_dangerously enabled" do
      around do |example|
        BlockKit.config.autofix_dangerously = true
        example.run
        BlockKit.config.autofix_dangerously = false
      end

      it "runs dangerous autofixers automatically" do
        block = block_class.new(text: "This is a very long text that exceeds the maximum length", items: ["1", "2", "3", "4", "5", "6", "7"])
        expect(block).not_to be_valid

        block.fix_validation_errors

        expect(block).to be_valid
        expect(block.text).to eq("This is a very long te...")
        expect(block.items).to eq(["1", "2", "3", "4", "5"])
      end
    end
  end
end
