require "spec_helper"

RSpec.shared_examples_for "a block that has plain text attributes" do |*attributes|
  attributes.each do |attribute|
    it { is_expected.to have_attribute(attribute).with_type(:block_kit_plain_text) }

    it_behaves_like "a block that has a DSL method",
      attribute: attribute,
      type: BlockKit::Composition::PlainText,
      actual_fields: {text: "Hello, world!", emoji: false},
      required_fields: [:text], yields: false
  end
end
