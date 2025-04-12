# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Types::Text do
  subject(:type) { described_class.instance }

  it "has a type" do
    expect(subject.type).to eq(:block_kit_text)
  end

  describe "#cast" do
    subject(:result) { type.cast(value) }

    context "when the value is a PlainText block" do
      let(:value) { BlockKit::Composition::PlainText.new(text: "Hello, world!") }

      it { is_expected.to eq(value) }
    end

    context "when the value is a Mrkdwn block" do
      let(:value) { BlockKit::Composition::Mrkdwn.new(text: "Hello, world!") }

      it { is_expected.to eq(value) }
    end

    context "when the value is nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when the value is a string" do
      let(:value) { "Hello, world!" }

      it "returns a Mrkdwn block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to eq("Hello, world!")
        expect(result.verbatim).to be_nil
      end
    end

    context "when the value is a Hash" do
      let(:value) { {text: "Hello, world!"} }

      it "returns a Mrkdwn block with default arguments" do
        expect(result).to be_a(BlockKit::Composition::Mrkdwn)
        expect(result.text).to eq("Hello, world!")
        expect(result.verbatim).to be_nil
      end

      context "when the value has a `type` key" do
        let(:value) { super().merge(type: "plain_text") }

        it "returns a block based on the type" do
          expect(result).to be_a(BlockKit::Composition::PlainText)
          expect(result.text).to eq("Hello, world!")
        end

        context "when the other keys do not match the type" do
          let(:value) { super().merge(type: "mrkdwn", emoji: true) }

          it "ignores the other keys" do
            expect(result).to be_a(BlockKit::Composition::Mrkdwn)
            expect(result.text).to eq("Hello, world!")
            expect(result.verbatim).to be_nil
          end
        end

        context "when the type is not recognized" do
          let(:value) { super().merge(type: "unknown") }

          it "returns a Mrkdwn block" do
            expect(result).to be_a(BlockKit::Composition::Mrkdwn)
            expect(result.text).to eq("Hello, world!")
            expect(result.verbatim).to be_nil
          end
        end
      end

      context "when the value has a `verbatim` key" do
        let(:value) { super().merge(verbatim: false) }

        it "returns a Mrkdwn block" do
          expect(result).to be_a(BlockKit::Composition::Mrkdwn)
          expect(result.text).to eq("Hello, world!")
          expect(result.verbatim).to be false
        end
      end

      context "when the value has an `emoji` key" do
        let(:value) { super().merge(emoji: false) }

        it "returns a PlainText block" do
          expect(result).to be_a(BlockKit::Composition::PlainText)
          expect(result.text).to eq("Hello, world!")
          expect(result.emoji).to be false
        end
      end

      context "when the value has both `verbatim` and `emoji` keys" do
        let(:value) { super().merge(verbatim: false, emoji: true) }

        it "prefers Mrkdwn" do
          expect(result).to be_a(BlockKit::Composition::Mrkdwn)
          expect(result.text).to eq("Hello, world!")
          expect(result.verbatim).to be false
        end
      end
    end
  end
end
