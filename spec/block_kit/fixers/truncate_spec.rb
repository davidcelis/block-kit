# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Fixers::Truncate do
  let(:block_class) do
    Class.new(BlockKit::Base) do
      attribute :text, :string
      validates :text, length: {maximum: 100}
    end
  end

  let(:attributes) { {text: "a" * (100 + 1)} }
  let(:model) { block_class.new(attributes) }

  subject(:fixer) { described_class.new(attribute: :text, maximum: 100) }

  describe "#fix" do
    let(:result) { fixer.fix(model) }

    it "truncates the attribute to the maximum length" do
      expect { result }.to change { model.text.length }.by(-1)

      expect(model.text).to eq("a" * 97 + "...")
    end

    context "when the attribute is nil" do
      let(:attributes) { {} }

      it "does nothing" do
        expect { result }.not_to change { model.text }
      end
    end

    context "when the attribute is blank" do
      let(:attributes) { {text: ""} }

      it "does nothing" do
        expect { result }.not_to change { model.text }
      end
    end

    context "when the attribute's length does not exceed the maximum" do
      let(:attributes) { {text: "a" * 100} }

      it "does nothing" do
        expect { result }.not_to change { model.text }
      end
    end

    context "when the attribute is enumerable" do
      let(:block_class) do
        Class.new(BlockKit::Base) do
          attribute :values, BlockKit::Types::Array.of(:string)
          validates :values, length: {maximum: 3}
        end
      end

      let(:attributes) { {values: (1..5).to_a} }

      subject(:fixer) { described_class.new(attribute: :values, maximum: 3) }

      it "truncates the list to the maximum length" do
        expect { result }.to change { model.values.length }.by(-2)

        expect(model.values).to eq(["1", "2", "3"])
      end

      context "when the attribute is nil" do
        let(:attributes) { {} }

        it "does nothing" do
          expect { result }.not_to change { model.values }
        end
      end

      context "when the attribute is empty" do
        let(:attributes) { {values: []} }

        it "does nothing" do
          expect { result }.not_to change { model.values }
        end
      end

      context "when the attribute's length does not exceed the maximum" do
        let(:attributes) { {values: (1..3).to_a} }

        it "does nothing" do
          expect { result }.not_to change { model.values }
        end
      end
    end
  end
end
