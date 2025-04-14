# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Set do
  context "with a scalar item type" do
    subject(:type) { described_class.of(:string) }

    describe "#cast" do
      it "converts all values to strings" do
        set = type.cast([:foo, 123, "bar"])
        expect(set.to_a).to eq(["foo", "123", "bar"])
        expect(set).to be_a(BlockKit::TypedSet)
      end

      it "handles nil" do
        expect(type.cast(nil)).to be_nil
      end

      it "wraps a single value in an set" do
        set = type.cast("foo")
        expect(set.to_a).to eq(["foo"])
        expect(set).to be_a(BlockKit::TypedSet)
      end

      it "removes nil elements" do
        set = ["foo", nil, :bar]
        typed_set = type.cast(set)
        expect(typed_set.to_a).to eq(["foo", "bar"])

        typed_set << nil
        expect(typed_set.to_a).to eq(["foo", "bar"])
      end
    end
  end
end
