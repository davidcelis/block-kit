# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Trigger, type: :model do
  subject(:trigger) { described_class.new(**attributes) }
  let(:attributes) { {url: "https://example.com"} }

  describe "#as_json" do
    it "serializes to JSON" do
      expect(trigger.as_json).to eq({
        url: "https://example.com"
      })
    end

    context "with customizable input parameters" do
      let(:attributes) do
        {
          url: "https://example.com",
          customizable_input_parameters: [
            BlockKit::Composition::InputParameter.new(name: "greeting", value: "Hello, world!")
          ]
        }
      end

      it "serializes to JSON with customizable input parameters" do
        expect(trigger.as_json).to eq({
          url: "https://example.com",
          customizable_input_parameters: [
            {name: "greeting", value: "Hello, world!"}
          ]
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to allow_value("http://example.com/").for(:url) }
    it { is_expected.to allow_value("https://example.com/").for(:url) }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:url) }
    it { is_expected.not_to allow_value("invalid_url").for(:url) }

    it { is_expected.to validate_presence_of(:customizable_input_parameters).allow_nil }

    it "validates the associated customizable input parameters" do
      trigger.customizable_input_parameters = [
        {name: "greeting", value: ""},
        {name: "other_parameter", value: "Some value"}
      ]
      expect(trigger).not_to be_valid
      expect(trigger.errors["customizable_input_parameters[0]"]).to include("is invalid: value can't be blank")
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:url).with_type(:string) }

    it { is_expected.to have_attribute(:customizable_input_parameters).with_type(:array, :block_kit_input_parameter) }

    it_behaves_like "a block with required attributes", :url
  end
end
