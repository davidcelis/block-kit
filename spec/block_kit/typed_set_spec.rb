# frozen_string_literal: true

require "spec_helper"
require "active_model/type"

RSpec.describe BlockKit::TypedSet do
  context "with a scalar item type" do
    subject(:set) { described_class.new(ActiveModel::Type::String.new, ["foo", :bar, "baz"]) }

    it "maintains type constraints and uniqueness when using #add" do
      set.add(123)
      expect(set.to_a).to eq(["foo", "bar", "baz", "123"])

      set << :foo
      expect(set.to_a).to eq(["foo", "bar", "baz", "123"])

      set.add(nil)
      expect(set.to_a).to eq(["foo", "bar", "baz", "123"])
    end

    it "maintains type constraints when using merge" do
      set.merge([123, :foo, "baz"])
      expect(set.to_a).to eq(["foo", "bar", "baz", "123"])
    end

    it "maintains type constraints when using replace" do
      set.replace([123, :foo, "baz"])
      expect(set.to_a).to eq(["123", "foo", "baz"])
    end

    it "maintains type constraints when performing set operations on other collections" do
      new_set = set + [123, 456]
      expect(new_set.to_a).to eq(["foo", "bar", "baz", "123", "456"])
      expect(new_set).to be_a(BlockKit::TypedSet)

      new_set = set.map { |item| item.to_sym }
      expect(new_set).to eq([:foo, :bar, :baz])
      expect(new_set).not_to be_a(BlockKit::TypedSet)

      intersection = set & ["foo", 123]
      expect(intersection.to_a).to eq(["foo"])
      expect(intersection).to be_a(BlockKit::TypedSet)

      union = set | ["foo", :foo, 123]
      expect(union.to_a).to eq(["foo", "bar", "baz", "123"])
      expect(union).to be_a(BlockKit::TypedSet)

      difference = set - ["foo", :bar]
      expect(difference.to_a).to eq(["bar", "baz"])
      expect(difference).to be_a(BlockKit::TypedSet)
    end
  end

  context "with a block type" do
    let(:set) { described_class.new(BlockKit::Types::Block.of_type(BlockKit::Composition::Option)) }

    it "raises an ArgumentError on initialize" do
      expect { set }.to raise_error(ArgumentError, "Only scalar item types are supported")
    end
  end
end
