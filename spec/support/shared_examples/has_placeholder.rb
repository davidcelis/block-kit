require "spec_helper"

RSpec.shared_examples_for "a block that has a placeholder" do
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

  it_behaves_like "a block that has plain text attributes", :placeholder
  it_behaves_like "a block that has plain text emoji assignment", :placeholder
end
