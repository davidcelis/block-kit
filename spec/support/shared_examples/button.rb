require "spec_helper"

RSpec.shared_examples_for "a button" do
  it { is_expected.to have_attribute(:text).with_type(:block_kit_plain_text) }
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
  it_behaves_like "a block that has plain text emoji assignment", :text
end
