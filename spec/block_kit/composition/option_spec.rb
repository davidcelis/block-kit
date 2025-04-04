# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Composition::Option, type: :model do
  subject(:option) { described_class.new(**attributes) }
  let(:attributes) do
    {
      text: "A great option",
      value: "option_1"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(option.as_json).to eq({
        text: {type: "plain_text", text: "A great option"},
        value: "option_1"
      })
    end

    context "with all attributes" do
      let(:attributes) { super().merge(description: "This option is great!") }

      it "serializes to JSON" do
        expect(option.as_json).to eq({
          text: {type: "plain_text", text: "A great option"},
          value: "option_1",
          description: {type: "plain_text", text: "This option is great!"}
        })
      end
    end
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(75) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_length_of(:value).is_at_most(150) }
    it { is_expected.to validate_length_of(:description).is_at_most(75).allow_blank }
  end

  context "attributes" do
    it { is_expected.to have_attribute(:text).with_type(:plain_text_block) }
    it { is_expected.to have_attribute(:value).with_type(:string) }
    it { is_expected.to have_attribute(:description).with_type(:plain_text_block) }
  end
end
