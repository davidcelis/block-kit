require "spec_helper"

RSpec.shared_examples_for "a block that has a placeholder" do
  it { is_expected.to have_attribute(:placeholder).with_type(:block_kit_plain_text) }

  describe "#as_json" do
    it "serializes the placeholder in as JSON" do
      subject.placeholder = "Enter something here"

      expect(subject.as_json).to include(
        placeholder: {type: "plain_text", text: "Enter something here"}
      )
    end
  end

  it { is_expected.to validate_presence_of(:placeholder).allow_nil }
  it { is_expected.to validate_length_of(:placeholder).is_at_most(150) }
end
