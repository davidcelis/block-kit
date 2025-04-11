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
end
