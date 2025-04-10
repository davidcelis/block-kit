# Source: https://github.com/sciencehistory/kithe/blob/master/spec/validators/array_inclusion_validator_spec.rb

require "spec_helper"

RSpec.describe BlockKit::Validators::AssociatedValidator do
  subject(:klass) do
    Class.new do
      def self.name = "Model"

      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :nested
      validates :nested, "block_kit/validators/associated": true

      def initialize(attributes = {})
        @nested = attributes.delete(:nested)

        super
      end
    end
  end

  let(:nested_klass) do
    Class.new do
      def self.name = "NestedModel"

      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :nested_attr_1, :string
      validates :nested_attr_1, presence: true

      attribute :nested_attr_2, :string
      validates :nested_attr_2, presence: true

      attr_accessor :deeply_nested
      validates :deeply_nested, "block_kit/validators/associated": true, allow_nil: true

      def initialize(attributes = {})
        @deeply_nested = attributes.delete(:deeply_nested)

        super
      end
    end
  end

  let(:deeply_nested_klass) do
    Class.new do
      def self.name = "DeeplyNestedModel"

      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :deeply_nested_attr_1, :string
      validates :deeply_nested_attr_1, presence: true

      attribute :deeply_nested_attr_2, :string
      validates :deeply_nested_attr_2, presence: true

      attr_accessor :deepest_nested
      validates :deepest_nested, "block_kit/validators/associated": true, allow_nil: true

      def initialize(attributes = {})
        @deepest_nested = attributes.delete(:deepest_nested)

        super
      end
    end
  end

  let(:deepest_nested_klass) do
    Class.new do
      def self.name = "DeepestNestedModel"

      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :deepest_nested_attr_1, :string
      validates :deepest_nested_attr_1, presence: true

      attribute :deepest_nested_attr_2, :string
      validates :deepest_nested_attr_2, presence: true
    end
  end

  it "validates the associated model" do
    nested = nested_klass.new(nested_attr_1: "Hello", nested_attr_2: "World")
    model = klass.new(nested: nested)
    expect(model).to be_valid

    nested.nested_attr_1 = nil
    expect(model).not_to be_valid
    expect(model.errors[:nested]).to include("is invalid: nested_attr_1 can't be blank")
  end

  it "creates JSON path-like error messages for deeply nested models" do
    deepest_model = deepest_nested_klass.new(deepest_nested_attr_1: "1", deepest_nested_attr_2: "2")
    deep_model = deeply_nested_klass.new(deeply_nested_attr_1: "1", deeply_nested_attr_2: "2", deepest_nested: deepest_model)
    nested_model = nested_klass.new(nested_attr_1: "1", nested_attr_2: "2", deeply_nested: deep_model)
    top_model = klass.new(nested: nested_model)

    expect(top_model).to be_valid
    expect(nested_model).to be_valid
    expect(deep_model).to be_valid
    expect(deepest_model).to be_valid

    # Make the deepest nested model invalid and test the resulting error message
    # at all levels of the hierarchy
    deepest_model.deepest_nested_attr_1 = ""

    expect(deepest_model).not_to be_valid
    expect(deepest_model.errors[:deepest_nested_attr_1]).to include("can't be blank")
    expect(deep_model).not_to be_valid
    expect(deep_model.errors[:deepest_nested]).to include("is invalid: deepest_nested_attr_1 can't be blank")
    expect(nested_model).not_to be_valid
    expect(nested_model.errors[:deeply_nested]).to include("is invalid: deepest_nested.deepest_nested_attr_1 can't be blank")
    expect(top_model).not_to be_valid
    expect(top_model.errors[:nested]).to include("is invalid: deeply_nested.deepest_nested.deepest_nested_attr_1 can't be blank")

    # Make the deeply nested model invalid too to create a separate message for higher levels
    deep_model.deeply_nested_attr_1 = ""

    expect(deepest_model).not_to be_valid
    expect(deepest_model.errors[:deepest_nested_attr_1]).to include("can't be blank")
    expect(deep_model).not_to be_valid
    expect(deep_model.errors[:deeply_nested_attr_1]).to include("can't be blank")
    expect(deep_model.errors[:deepest_nested]).to include("is invalid: deepest_nested_attr_1 can't be blank")
    expect(nested_model).not_to be_valid
    expect(nested_model.errors[:deeply_nested]).to include("is invalid: deeply_nested_attr_1 can't be blank, deepest_nested.deepest_nested_attr_1 can't be blank")
    expect(top_model).not_to be_valid
    expect(top_model.errors[:nested]).to include("is invalid: deeply_nested.deeply_nested_attr_1 can't be blank, deeply_nested.deepest_nested.deepest_nested_attr_1 can't be blank")
  end

  context "with an array of associated models" do
    let(:nested) do
      [
        nested_klass.new(nested_attr_1: "1", nested_attr_2: "2"),
        nested_klass.new(nested_attr_1: "1", nested_attr_2: "2")
      ]
    end
    let(:model) { klass.new(nested: nested) }

    it "validates each associated model" do
      expect(model).to be_valid
      nested[1].nested_attr_2 = nil

      expect(model).not_to be_valid
      expect(model.errors).not_to have_key("nested[0]")
      expect(model.errors["nested[1]"]).to include("is invalid: nested_attr_2 can't be blank")
    end

    it "handles nested models within arrays" do
      # Create an array with a deeply nested structure
      deepest_nested_1 = deepest_nested_klass.new(deepest_nested_attr_1: "1", deepest_nested_attr_2: "2")
      deepest_nested_2 = deepest_nested_klass.new(deepest_nested_attr_1: "1", deepest_nested_attr_2: "2")
      deeply_nested_1 = deeply_nested_klass.new(deeply_nested_attr_1: "1", deeply_nested_attr_2: "2", deepest_nested: [deepest_nested_1, deepest_nested_2])
      deeply_nested_2 = deeply_nested_klass.new(deeply_nested_attr_1: "1", deeply_nested_attr_2: "2", deepest_nested: [deepest_nested_1, deepest_nested_2])
      nested_1 = nested_klass.new(nested_attr_1: "1", nested_attr_2: "2", deeply_nested: [deeply_nested_1, deeply_nested_2])
      nested_2 = nested_klass.new(nested_attr_1: "1", nested_attr_2: "2", deeply_nested: [deeply_nested_1, deeply_nested_2])
      top_model = klass.new(nested: [nested_1, nested_2])
      expect(top_model).to be_valid

      # Make a deeply nested model invalid and test the resulting error message
      # at all levels of the hierarchy
      deeply_nested_1.deeply_nested_attr_2 = ""
      deeply_nested_2.deeply_nested_attr_1 = ""
      expect(deeply_nested_1).not_to be_valid
      expect(deeply_nested_1.errors[:deeply_nested_attr_2]).to include("can't be blank")
      expect(deeply_nested_2).not_to be_valid
      expect(deeply_nested_2.errors[:deeply_nested_attr_1]).to include("can't be blank")

      expect(nested_1).not_to be_valid
      expect(nested_1.errors["deeply_nested[0]"]).to include("is invalid: deeply_nested_attr_2 can't be blank")
      expect(nested_1.errors["deeply_nested[1]"]).to include("is invalid: deeply_nested_attr_1 can't be blank")
      expect(nested_2).not_to be_valid
      expect(nested_2.errors["deeply_nested[0]"]).to include("is invalid: deeply_nested_attr_2 can't be blank")
      expect(nested_2.errors["deeply_nested[1]"]).to include("is invalid: deeply_nested_attr_1 can't be blank")
      expect(top_model).not_to be_valid
      expect(top_model.errors["nested[0]"]).to include("is invalid: deeply_nested[0].deeply_nested_attr_2 can't be blank, deeply_nested[1].deeply_nested_attr_1 can't be blank")
      expect(top_model.errors["nested[1]"]).to include("is invalid: deeply_nested[0].deeply_nested_attr_2 can't be blank, deeply_nested[1].deeply_nested_attr_1 can't be blank")
    end
  end
end
