# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::RichText::Elements::TextStyle, type: :model do
  subject(:element) { described_class.new(attributes) }
  let(:attributes) { {bold: true} }

  it_behaves_like "a class that yields self on initialize"

  describe "#as_json" do
    it "serializes to JSON" do
      expect(element.as_json).to eq({bold: true})
    end

    context "with all attributes" do
      let(:attributes) do
        {
          bold: nil,
          italic: false,
          strike: true,
          code: false
        }
      end

      it "serializes to JSON and omits nils" do
        expect(element.as_json).to eq({
          italic: false,
          strike: true,
          code: false
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:bold).with_type(:boolean) }
    it { is_expected.to have_attribute(:italic).with_type(:boolean) }
    it { is_expected.to have_attribute(:strike).with_type(:boolean) }
    it { is_expected.to have_attribute(:code).with_type(:boolean) }
  end

  context "validations" do
    it { is_expected.to be_valid }
  end
end
