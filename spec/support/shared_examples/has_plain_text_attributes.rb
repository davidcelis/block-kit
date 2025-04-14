require "spec_helper"

RSpec.shared_examples_for "a block that has plain text attributes" do |*attributes|
  attributes.each do |attribute|
    it { is_expected.to have_attribute(attribute).with_type(:block_kit_plain_text) }

    describe "##{attribute}" do
      it "gets or sets depending on the arguments" do
        subject.public_send(:"#{attribute}=", "Hello, world!")
        expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
        expect(subject.public_send(attribute).text).to eq("Hello, world!")
        expect(subject.public_send(attribute).emoji).to be_nil

        subject.public_send(attribute, text: "Some new text", emoji: false)
        expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
        expect(subject.public_send(attribute).text).to eq("Some new text")
        expect(subject.public_send(attribute).emoji).to be(false)

        subject.public_send(attribute, text: "More new text")
        expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
        expect(subject.public_send(attribute).text).to eq("More new text")
        expect(subject.public_send(attribute).emoji).to be_nil

        subject.public_send(attribute, emoji: true)
        expect(subject.public_send(attribute)).to be_a(BlockKit::Composition::PlainText)
        expect(subject.public_send(attribute).text).to be_nil
        expect(subject.public_send(attribute).emoji).to be(true)
      end
    end
  end
end
