# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Generic do
  block_class = Class.new(BlockKit::Base) do
    self.type = :person

    attribute :name, :string
    attribute :age, :integer
    attribute :admin, :boolean
    attribute :created_at, :datetime
  end

  let(:type_class) { described_class.of_type(block_class) }

  it "does not recreate the class if it already exists" do
    duplicate_class = described_class.of_type(block_class)

    expect(type_class).to eql(duplicate_class)
  end

  describe "#type" do
    it "prefixes the type with 'block_kit'" do
      expect(type_class.type).to eq(:block_kit_person)
    end
  end

  describe "#cast" do
    subject { type_class.cast(value) }

    context "when given a block object of the same type" do
      let(:value) { block_class.new(name: "Michael Bluth", age: 36, admin: true, created_at: "2025-04-09T12:02:25Z") }

      it "returns the same object" do
        expect(subject).to be_a(block_class)
        expect(subject).to eq(value)
      end
    end

    context "when given a Hash" do
      let(:value) { {name: "G.O.B.", age: 39, admin: false, updated_at: Time.now} }

      it "returns a new block object ignoring unknown keys" do
        expect(subject).to be_a(block_class)
        expect(subject.name).to eq(value[:name])
        expect(subject.age).to eq(value[:age])
        expect(subject.admin).to eq(value[:admin])
        expect(subject.created_at).to be_nil
      end
    end

    context "when given a block object of a different type" do
      let(:value) { BlockKit::Layout::Divider.new }

      it { is_expected.to be_nil }
    end

    context "when given other types" do
      let(:value) { "not a block" }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
