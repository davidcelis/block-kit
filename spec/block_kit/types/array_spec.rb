# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Array do
  context "with a scalar item type" do
    subject(:type) { described_class.of(:string) }

    describe "#cast" do
      it "converts all values to strings" do
        array = type.cast([:foo, 123, "bar"])
        expect(array).to eq(["foo", "123", "bar"])
      end

      it "handles nil" do
        expect(type.cast(nil)).to be_nil
      end

      it "wraps a single value in an array" do
        expect(type.cast("foo")).to eq(["foo"])
      end

      it "removes nil elements" do
        array = ["foo", nil, "bar"]
        typed_array = type.cast(array)
        expect(typed_array).to eq(["foo", "bar"])

        typed_array << nil
        expect(typed_array).to eq(["foo", "bar"])
      end
    end

    describe "returned array" do
      subject(:array) { type.cast(["foo", "bar", "baz"]) }

      it "maintains type constraints when using <<" do
        array << 123
        expect(array).to eq(["foo", "bar", "baz", "123"])
      end

      it "maintains type constraints when using push" do
        array.push(123, 456)
        expect(array).to eq(["foo", "bar", "baz", "123", "456"])
      end

      it "maintains type constraints when using unshift" do
        array.unshift(123, 456)
        expect(array).to eq(["123", "456", "foo", "bar", "baz"])
      end

      describe "#[]= (index assignment)" do
        it "casts and assigns a single value" do
          array[0] = 123
          expect(array).to eq(["123", "bar", "baz"])
        end

        it "replaces a range with a single value" do
          array[0..1] = 123
          expect(array).to eq(["123", "baz"])
        end

        it "replaces a range with an array of values" do
          array[0..1] = [123, 456]
          expect(array).to eq(["123", "456", "baz"])
        end

        it "replaces a slice with an array of values" do
          array[0, 2] = [123, 456]
          expect(array).to eq(["123", "456", "baz"])
        end

        it "replaces a slice with a single value" do
          array[0, 2] = 123
          expect(array).to eq(["123", "baz"])
        end

        it "removes nils after assignment" do
          array[0] = nil
          expect(array).to eq(["bar", "baz"])
        end

        it "handles edge cases with empty arrays" do
          array[0..1] = []
          expect(array).to eq(["baz"])
        end

        it "keeps valid values while removing nil ones in multi-assignment" do
          array[0..2] = [123, nil, 456]
          expect(array).to eq(["123", "456"])
        end
      end

      it "maintains type constraints when using concat" do
        array.concat([123, 456])
        expect(array).to eq(["foo", "bar", "baz", "123", "456"])
      end

      it "returns new, untyped arrays when not modifying in place" do
        new_array = array + [123, 456]
        expect(new_array).to eq(["foo", "bar", "baz", 123, 456])
        expect(new_array).not_to be_a(BlockKit::Types::Array::TypedArray)

        new_array = array.map { |item| item.to_sym }
        expect(new_array).to eq([:foo, :bar, :baz])
        expect(new_array).not_to be_a(BlockKit::Types::Array::TypedArray)
      end
    end
  end

  describe ".of with a single block type" do
    let(:type) { described_class.of(BlockKit::Composition::Option) }

    it "creates an array type that casts elements using the specified type" do
      option1 = {value: "value1", text: "Text 1"}
      option2 = {value: "value2", text: "Text 2"}

      array = type.cast([option1, option2])

      expect(array).to all(be_a(BlockKit::Composition::Option))
      expect(array[0].value).to eq("value1")
      expect(array[1].value).to eq("value2")
    end

    it "maintains type constraints when elements are added" do
      array = type.cast([])
      array << {value: "value1", text: "Text 1"}

      expect(array[0]).to be_a(BlockKit::Composition::Option)
      expect(array[0].value).to eq("value1")

      expect { array << "invalid_option" }.not_to change { array.length }
    end

    describe "#[]= (index assignment)" do
      let(:array) { type.cast([]) }
      let(:option1) { {value: "value1", text: "Text 1"} }
      let(:option2) { {value: "value2", text: "Text 2"} }
      let(:option3) { {value: "value3", text: "Text 3"} }

      before do
        array.push(option1, option2)
      end

      it "casts and assigns a single value" do
        array[0] = option3
        expect(array[0]).to be_a(BlockKit::Composition::Option)
        expect(array[0].value).to eq("value3")
      end

      it "replaces a range with array of values" do
        array[0..1] = [option3]
        expect(array.length).to eq(1)
        expect(array[0]).to be_a(BlockKit::Composition::Option)
        expect(array[0].value).to eq("value3")
      end

      it "removes invalid values during assignment" do
        array[0] = "invalid_option"
        expect(array.length).to eq(1)
        expect(array[0].value).to eq("value2") # Original removed, second item became first
      end

      it "filters out nil values after assignment" do
        array[0] = nil
        expect(array.length).to eq(1)
        expect(array[0].value).to eq("value2")
      end

      it "keeps valid values while removing invalid ones in multi-assignment" do
        array.push(option1) # Now have: option1, option2, option1
        array[0..2] = [option3, "invalid_option", option2]
        expect(array.length).to eq(2)
        expect(array[0].value).to eq("value3")
        expect(array[1].value).to eq("value2")
      end
    end

    it "returns new, untyped arrays when not modifying in place" do
      option1 = {value: "value1", text: "Text 1"}
      option2 = {value: "value2", text: "Text 2"}

      array = type.cast([option1, option2])
      new_array = array + [{value: "value3", text: "Text 3"}]

      expect(new_array).not_to be_a(BlockKit::Types::Array::TypedArray)
      expect(new_array.last).to be_a(Hash)

      new_array = array.map(&:as_json)
      expect(new_array).to all(be_a(Hash))
    end
  end

  describe ".of with multiple block types" do
    # Create test block classes for this spec
    test_block_a_class = Class.new(BlockKit::Block) do
      def self.type
        "test_block_a"
      end
    end

    test_block_b_class = Class.new(BlockKit::Block) do
      def self.type
        "test_block_b"
      end
    end

    let(:type) { described_class.of(test_block_a_class, test_block_b_class) }

    it "rejects multiple types that aren't all blocks" do
      expect {
        described_class.of(test_block_a_class, :string)
      }.to raise_error(ArgumentError, "Multiple types are only supported for Block classes")
    end

    it "creates an array type that casts blocks by their type" do
      block_a = {type: "test_block_a"}
      block_b = {type: "test_block_b"}

      array = type.cast([block_a, block_b])

      expect(array[0]).to be_a(test_block_a_class)
      expect(array[1]).to be_a(test_block_b_class)
    end

    it "maintains type constraints when elements are added" do
      array = type.cast([])
      array << {type: "test_block_a"}
      array << {type: "test_block_b"}

      expect(array[0]).to be_a(test_block_a_class)
      expect(array[1]).to be_a(test_block_b_class)

      # Add an unknown type
      expect { array << {type: "unknown_type"} }.not_to change { array.length }
    end

    it "works with actual block instances" do
      block_a = test_block_a_class.new
      block_b = test_block_b_class.new

      array = type.cast([block_a, block_b])

      expect(array[0]).to be_a(test_block_a_class)
      expect(array[1]).to be_a(test_block_b_class)

      # Add another instance
      array << test_block_a_class.new
      expect(array[2]).to be_a(test_block_a_class)
    end

    describe "#[]= (index assignment)" do
      let(:array) { type.cast([]) }
      let(:block_a) { {type: "test_block_a"} }
      let(:block_b) { {type: "test_block_b"} }
      let(:block_a_instance) { test_block_a_class.new }
      let(:block_b_instance) { test_block_b_class.new }

      before do
        array.push(block_a, block_b)
      end

      it "casts and assigns a single hash value by type" do
        array[0] = {type: "test_block_b"}
        expect(array[0]).to be_a(test_block_b_class)
      end

      it "assigns block instances directly" do
        array[0] = block_b_instance
        expect(array[0]).to be_a(test_block_b_class)
        expect(array[0]).to eq(block_b_instance)
      end

      it "handles range replacement with mixed types" do
        array[0..1] = [{type: "test_block_a"}, block_b_instance]
        expect(array[0]).to be_a(test_block_a_class)
        expect(array[1]).to be_a(test_block_b_class)
        expect(array[1]).to eq(block_b_instance)
      end

      it "handles slice replacement" do
        array[0, 2] = [{type: "test_block_b"}, {type: "test_block_a"}]
        expect(array[0]).to be_a(test_block_b_class)
        expect(array[1]).to be_a(test_block_a_class)
      end

      it "removes unknown block types" do
        array[0] = {type: "unknown_type"}
        expect(array.length).to eq(1)
        expect(array[0]).to be_a(test_block_b_class) # Original removed, second item became first
      end

      it "filters out nil values after assignment" do
        array[0] = nil
        expect(array.length).to eq(1)
        expect(array[0]).to be_a(test_block_b_class)
      end

      it "keeps valid values while removing invalid ones in multi-assignment" do
        # Now have: block_a, block_b
        array[0..1] = [block_a_instance, {type: "unknown_type"}, block_b_instance]
        expect(array.length).to eq(2)
        expect(array[0]).to be_a(test_block_a_class)
        expect(array[1]).to be_a(test_block_b_class)
      end
    end
  end
end
