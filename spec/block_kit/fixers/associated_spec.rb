# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Fixers::Associated do
  let(:block_class) do
    Class.new(BlockKit::Block) do
      def self.name = "TestBlock"

      attr_accessor :nested
      validates :nested, "block_kit/validators/associated": true

      def initialize(attributes = {})
        @nested = attributes.delete(:nested)

        super
      end
    end
  end

  let(:nested_block_class) do
    Class.new(BlockKit::Block) do
      def self.name = "NestedBlock"

      attribute :nested_attribute_1, :string
      attribute :nested_attribute_2, BlockKit::Types::Array.of(:string)
      attr_accessor :deeply_nested

      validates :nested_attribute_1, length: {maximum: 100}
      fixes(:nested_attribute_1, truncate: {maximum: 100})

      validates :nested_attribute_2, presence: true, allow_nil: true
      fixes(:nested_attribute_2, null_value: {error_types: [:blank]})

      validates :deeply_nested, "block_kit/validators/associated": true

      def initialize(attributes = {})
        @nested = attributes.delete(:nested)

        super
      end
    end
  end

  let(:deeply_nested_block_class) do
    Class.new(BlockKit::Block) do
      def self.name = "DeeplyNestedBlock"

      attribute :deeply_nested_attribute_1, :string
      attribute :deeply_nested_attribute_2, BlockKit::Types::Array.of(:string)

      validates :deeply_nested_attribute_1, length: {maximum: 10}
      fixes :deeply_nested_attribute_1, truncate: {maximum: 10}

      validates :deeply_nested_attribute_2, length: {maximum: 5}
      fixes :deeply_nested_attribute_2, truncate: {maximum: 5}
    end
  end

  let(:nested) do
    nested_block_class.new(
      nested_attribute_1: "a" * 101,
      nested_attribute_2: [],
      deeply_nested: deeply_nested_block_class.new(
        deeply_nested_attribute_1: "b" * 11,
        deeply_nested_attribute_2: (1..10).to_a
      )
    )
  end

  let(:attributes) { {nested: nested} }
  let(:model) { block_class.new(attributes) }

  subject(:fixer) { described_class.new(attribute: :nested) }

  describe "#fix" do
    let(:result) { fixer.fix(model) }

    it "runs configured fixers on the nested attribute" do
      expect {
        result
      }.to change {
        nested.nested_attribute_1.length
      }.by(-1).and change {
        nested.nested_attribute_2
      }.to(nil)

      expect(model.nested.nested_attribute_1).to eq("a" * 97 + "...")
      expect(model.nested.deeply_nested.deeply_nested_attribute_1.length).to eq(11)
      expect(model.nested.deeply_nested.deeply_nested_attribute_2.length).to eq(10)
    end

    context "when the attribute is nil" do
      let(:attributes) { {} }

      it "does nothing" do
        expect { result }.not_to change { model.nested }
      end
    end

    context "when the attribute is enumerable" do
      let(:nested) do
        [
          nested_block_class.new(nested_attribute_1: "a" * 101, nested_attribute_2: ["hi"]),
          nested_block_class.new(nested_attribute_1: "b" * 100, nested_attribute_2: ["hi"]),
          nested_block_class.new(nested_attribute_1: "c" * 101, nested_attribute_2: [])
        ]
      end

      it "fixes each nested item" do
        expect {
          result
        }.to change {
          model.nested.first.nested_attribute_1.length
        }.by(-1).and change {
          model.nested.last.nested_attribute_1.length
        }.by(-1).and change {
          model.nested.last.nested_attribute_2
        }.to(nil)

        expect(model.nested[0].nested_attribute_1).to eq("a" * 97 + "...")
        expect(model.nested[0].nested_attribute_2).to eq(nested[0].nested_attribute_2)
        expect(model.nested[0].nested_attribute_2).to eq(nested[0].nested_attribute_2)
        expect(model.nested[1].nested_attribute_1).to eq(nested[1].nested_attribute_1)
        expect(model.nested[1].nested_attribute_2).to eq(nested[1].nested_attribute_2)
        expect(model.nested[2].nested_attribute_1).to eq("c" * 97 + "...")
      end
    end

    context "when the nested attributes fix more deeply nested attributes" do
      before do
        nested_block_class.fixes(:deeply_nested, associated: true)
      end

      it "fixes the deeply nested attributes" do
        expect {
          result
        }.to change {
          model.nested.deeply_nested.deeply_nested_attribute_1.length
        }.by(-1).and change {
          model.nested.deeply_nested.deeply_nested_attribute_2.length
        }.by(-5)

        expect(model.nested.deeply_nested.deeply_nested_attribute_1).to eq("b" * 7 + "...")
        expect(model.nested.deeply_nested.deeply_nested_attribute_2).to eq((1..5).to_a.map(&:to_s))
      end
    end
  end
end
