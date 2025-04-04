# Source: https://github.com/sciencehistory/kithe/blob/master/spec/validators/array_inclusion_validator_spec.rb

require "spec_helper"

RSpec.describe BlockKit::Validators::ArrayInclusionValidator do
  describe "in:" do
    subject(:klass) do
      Class.new do
        def self.name = "MyModel"

        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :str_array
        validates :str_array, "block_kit/validators/array_inclusion": {in: ["one", "two", "three"]}
      end
    end

    it "validates inclusion" do
      expect(klass.new(str_array: ["one", "two"])).to be_valid
      expect(klass.new(str_array: ["one", "two", "one"])).to be_valid
    end

    it "allows empty array" do
      expect(klass.new(str_array: [])).to be_valid
    end

    it "allows nil" do
      expect(klass.new).to be_valid
    end

    it "rejects invalid" do
      expect(klass.new(str_array: ["one", "extra"])).to be_invalid
      expect(klass.new(str_array: ["extra"])).to be_invalid
    end

    it "has an error message" do
      work = klass.new(str_array: ["one", "extra"])
      work.valid?

      expect(work.errors[:str_array]).to include("is not included in the list")
    end
  end

  describe "proc:" do
    subject(:klass) do
      Class.new do
        def self.name = "MyModel"

        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :str_array_proc
        validates :str_array_proc, "block_kit/validators/array_inclusion": {proc: ->(v) { v != "BAD" }}
      end
    end

    it "in-validates" do
      expect(klass.new(str_array_proc: ["one", "BAD"])).to be_invalid
    end

    it "validates" do
      expect(klass.new(str_array_proc: ["one", "two", "bad"])).to be_valid
    end
  end

  describe "custom formatted error message" do
    subject(:klass) do
      Class.new do
        def self.name = "MyCustomModel"

        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :str_array
        validates :str_array, "block_kit/validators/array_inclusion": {in: ["one", "two", "three"], message: "option %{rejected_values} not allowed"}
      end
    end

    it "has good message" do
      work = klass.new(str_array: ["one", "bad", "bad", "baddy"])
      expect(work).to be_invalid
      expect(work.errors[:str_array]).to eq(["option \"bad\",\"baddy\" not allowed"])
    end
  end
end
