# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Fixers::NullValue do
  let(:block_class) do
    Class.new(BlockKit::Block) do
      def self.name = "TestBlock"

      attribute :color, :string
      validates :color, presence: true, inclusion: {in: %w[red green blue]}
    end
  end

  let(:attributes) { {color: "invalid"} }
  let(:model) { block_class.new(attributes) }

  let(:error_types) { [:blank, :inclusion] }
  subject(:fixer) { described_class.new(attribute: :color, error_types: error_types) }

  describe "#fix" do
    let(:result) { fixer.fix(model) }

    context "inclusion errors" do
      it "fixes the invalid attribute by setting it to nil" do
        expect { result }.to change { model.color }.from("invalid").to(nil)
      end

      context "when the error type is not included" do
        let(:error_types) { [:blank] }

        it "does not fix the error" do
          expect { result }.not_to change { model.color }
        end
      end

      context "when the attribute is nil" do
        let(:attributes) { {} }

        it "does nothing" do
          expect { result }.not_to change { model.color }
        end
      end

      context "for enumerable attributes" do
        let(:block_class) do
          Class.new(BlockKit::Block) do
            def self.name = "TestBlock"

            attribute :colors, BlockKit::Types::Array.of(:string)
            validates :colors, presence: true, "block_kit/validators/array_inclusion": {in: %w[red green blue]}
          end
        end

        let(:attributes) { {colors: ["red", "invalid", "blue", "red", "yellow", "green", "blue"]} }

        subject(:fixer) { described_class.new(attribute: :colors, error_types: error_types) }

        it "fixes the invalid attribute by removing invalid values" do
          expect { result }.to change { model.colors.length }.by(-2)
          expect(model.colors).to eq(["red", "blue", "red", "green", "blue"])
        end

        context "when the attribute is already valid" do
          let(:attributes) { {colors: ["red", "green"]} }

          it "does nothing" do
            expect { result }.not_to change { model.colors }
          end
        end

        context "when the attribute is empty" do
          let(:attributes) { {colors: []} }

          it "replaces it with nil" do
            expect { result }.to change { model.colors }.to(nil)
          end

          context "when the error type is not included" do
            let(:error_types) { [:inclusion] }

            it "does nothing" do
              expect { result }.not_to change { model.colors }
            end
          end
        end
      end
    end

    context "blank errors" do
      let(:block_class) do
        Class.new(BlockKit::Block) do
          def self.name = "TestBlock"

          attribute :color, :string
          validates :color, presence: true
        end
      end

      let(:attributes) { {color: ""} }

      it "fixes the attribute by setting it to nil" do
        expect { result }.to change { model.color }.from("").to(nil)
      end

      context "when the attribute is nil" do
        let(:attributes) { {} }

        it "does nothing" do
          expect { result }.not_to change { model.color }
        end
      end

      context "when the error type is not included" do
        let(:error_types) { [:inclusion] }

        it "does not fix the error" do
          expect { result }.not_to change { model.color }

          expect(model).not_to be_valid
          expect(model.errors[:color]).to include("can't be blank")
        end
      end

      context "for enumerable attributes" do
        let(:block_class) do
          Class.new(BlockKit::Block) do
            def self.name = "TestBlock"

            attribute :colors, BlockKit::Types::Array.of(:string)
            validates :colors, presence: true
          end
        end

        let(:attributes) { {colors: []} }

        subject(:fixer) { described_class.new(attribute: :colors, error_types: error_types) }

        it "fixes the invalid attribute by nullifying it" do
          expect { result }.to change { model.colors }.to(nil)
        end

        context "when the attribute is not blank" do
          let(:attributes) { {colors: ["red", "yellow"]} }

          it "does nothing" do
            expect { result }.not_to change { model.colors }
          end
        end
      end
    end
  end
end
