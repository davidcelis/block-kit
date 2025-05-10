# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::InputParameter, type: :model do
  subject(:input_parameter) { described_class.new(**attributes) }
  let(:attributes) do
    {
      name: "greeting",
      value: "Hello, world!"
    }
  end

  it_behaves_like "a class that yields self on initialize"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(input_parameter.as_json).to eq({
        name: "greeting",
        value: "Hello, world!"
      })
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
  end

  context "attributes" do
    it { is_expected.to have_attribute(:name).with_type(:string) }
    it { is_expected.to have_attribute(:value).with_type(:string) }
  end
end
