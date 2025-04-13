require "spec_helper"

RSpec.shared_examples_for "a block that has plain text emoji assignment" do |*attributes|
  attributes.each do |attribute|
    describe "#initialize" do
      context "with only #{attribute}" do
        let(:attributes) { {attribute => "Hello, world!"} }

        it "creates a PlainText object with no emoji value" do
          expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
          expect(subject.public_send(attribute).text).to eq("Hello, world!")
          expect(subject.public_send(attribute).emoji).to be_nil
        end
      end

      context "with #{attribute} and emoji" do
        let(:attributes) { {attribute => "Hello, world!", :emoji => false} }

        it "creates a PlainText object with the specified emoji value" do
          expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
          expect(subject.public_send(attribute).text).to eq("Hello, world!")
          expect(subject.public_send(attribute).emoji).to be false
        end
      end

      context "with only emoji" do
        let(:attributes) { {emoji: true} }

        it "creates an empty PlainText object with the specified emoji value" do
          expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
          expect(subject.public_send(attribute).text).to be_nil
          expect(subject.public_send(attribute).emoji).to be true
        end
      end
    end

    describe "##{attribute}=" do
      let(:attributes) { {attribute => BlockKit::Composition::PlainText.new(text: "Hello, world!", emoji: false)} }

      it "preserves the existing emoji attribute when setting text from a String" do
        subject.public_send(:"#{attribute}=", "New text")

        text = subject.public_send(attribute)
        expect(text).to be_a(BlockKit::Composition::PlainText)
        expect(text.text).to eq("New text")
        expect(text.emoji).to be false
      end

      it "overrides existing emoji attributes when setting text from a Hash" do
        subject.public_send(:"#{attribute}=", {text: "New text"})

        text = subject.public_send(attribute)
        expect(text).to be_a(BlockKit::Composition::PlainText)
        expect(text.text).to eq("New text")
        expect(text.emoji).to be_nil
      end

      it "overrides existing emoji attributes when setting text from a PlainText object" do
        subject.public_send(:"#{attribute}=", BlockKit::Composition::PlainText.new(text: "New text", emoji: true))

        text = subject.public_send(attribute)
        expect(text).to be_a(BlockKit::Composition::PlainText)
        expect(text.text).to eq("New text")
        expect(text.emoji).to be true
      end
    end
  end
end
