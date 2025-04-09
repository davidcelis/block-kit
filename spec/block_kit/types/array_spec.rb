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
        expect(type.cast(["foo", nil, "bar"])).to eq(["foo", "bar"])
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

      it "maintains type constraints when using index assignment" do
        array[0] = 123
        expect(array).to eq(["123", "bar", "baz"])
      end

      it "maintains type constraints when using range assignment" do
        array[0..1] = [123, 456]
        expect(array).to eq(["123", "456", "baz"])
      end

      it "maintains type constraints when using slice assignment" do
        array[0, 2] = [123, 456]
        expect(array).to eq(["123", "456", "baz"])
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

  describe ".of" do
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

      array << "invalid_option"
      expect(array.last).to be_nil
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
end
