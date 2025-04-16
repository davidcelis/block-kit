require "spec_helper"

RSpec.shared_examples_for "a button" do
  it { is_expected.to have_attribute(:style).with_type(:string) }
  it { is_expected.to have_attribute(:accessibility_label).with_type(:string) }

  describe "#as_json" do
    let(:attributes) do
      {
        text: "My Button",
        style: "primary",
        accessibility_label: "My Button Label"
      }
    end

    it "serializes button attributes as JSON" do
      expect(subject.as_json).to include(
        text: {type: "plain_text", text: "My Button"},
        style: "primary",
        accessibility_label: "My Button Label"
      )
    end
  end

  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_length_of(:text).is_at_most(75) }
  it { is_expected.to validate_presence_of(:style).allow_nil }
  it { is_expected.to validate_inclusion_of(:style).in_array(%w[primary danger]).allow_nil }
  it { is_expected.to validate_presence_of(:accessibility_label).allow_nil }
  it { is_expected.to validate_length_of(:accessibility_label).is_at_most(75) }

  it_behaves_like "a block with an action_id"
  it_behaves_like "a block that has plain text attributes", :text
  it_behaves_like "a block that has plain text emoji assignment", :text

  it_behaves_like "a block that fixes validation errors", attribute: :text, truncate: {maximum: BlockKit::Elements::BaseButton::MAX_TEXT_LENGTH}
  it_behaves_like "a block that fixes validation errors",
    attribute: :style,
    null_value: {
      valid_values: BlockKit::Elements::BaseButton::VALID_STYLES + [nil],
      invalid_values: [
        {before: "invalid", after: nil},
        {before: "", after: nil}
      ]
    }
  it_behaves_like "a block that fixes validation errors",
    attribute: :accessibility_label,
    truncate: {maximum: BlockKit::Elements::BaseButton::MAX_ACCESSIBILITY_LABEL_LENGTH},
    null_value: {
      valid_values: ["An accessible label", nil],
      invalid_values: [{before: "", after: nil}]
    }
end
