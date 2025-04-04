# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::OverflowOption, type: :model do
  subject(:option) { described_class.new(**attributes) }
  let(:attributes) do
    {
      text: "A great option",
      value: "option_1"
    }
  end

  it { is_expected.to be_a(BlockKit::Composition::Option) }

  describe "#as_json" do
    context "with all attributes" do
      let(:attributes) { super().merge(description: "This option is great!", url: "https://example.com/") }

      it "serializes to JSON" do
        expect(option.as_json).to eq({
          text: {type: "plain_text", text: "A great option"},
          value: "option_1",
          description: {type: "plain_text", text: "This option is great!"},
          url: "https://example.com/"
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_length_of(:url).is_at_most(3000).allow_nil }
  end

  context "attributes" do
    it { is_expected.to have_attribute(:url).with_type(:string) }
  end
end
