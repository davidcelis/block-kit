# Source: https://github.com/sciencehistory/kithe/blob/master/spec/validators/array_inclusion_validator_spec.rb

require "spec_helper"

RSpec.describe BlockKit::Validators::AssociatedValidator do
  subject(:associated_klass) do
    Class.new do
      def self.name = "MyAssociatedModel"

      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :text, :string
      validates :text, presence: true
    end
  end

  subject(:klass) do
    Class.new do
      def self.name = "MyModel"

      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :associated
      validates :associated, "block_kit/validators/associated": true

      def initialize(associated: nil)
        @associated = associated
      end
    end
  end

  it "validates the associated model" do
    associated = associated_klass.new(text: "Hello")
    model = klass.new(associated: associated)
    expect(model).to be_valid

    associated.text = nil
    expect(model).not_to be_valid
    expect(model.errors[:associated]).to include("is invalid: text can't be blank")
  end

  context "with an array of associated models" do
    let(:associated) { [associated_klass.new(text: "Hello"), associated_klass.new(text: nil)] }
    let(:model) { klass.new(associated: associated) }

    it "validates each associated model" do
      expect(model).not_to be_valid
      expect(model.errors["associated[1]"]).to include("is invalid: text can't be blank")
    end

    it "validates the index of the associated model" do
      expect(model.errors).not_to have_key("associated[0]")
    end
  end
end
