require "spec_helper"

RSpec.shared_examples_for "a block with an action_id" do
  it { is_expected.to have_attribute(:action_id).with_type(:string) }

  it "includes `action_id` when serialized and present" do
    subject.action_id = nil
    expect(subject.as_json).not_to have_key(:action_id)

    subject.action_id = "action_id"
    expect(subject.as_json[:action_id]).to eq("action_id")
  end

  it { is_expected.to validate_length_of(:action_id).is_at_most(255).allow_nil }

  it_behaves_like "a block that fixes validation errors",
    attribute: :action_id,
    truncate: {maximum: BlockKit::Elements::Base::MAX_ACTION_ID_LENGTH, dangerous: true},
    null_value: {
      valid_values: ["anything", nil],
      invalid_values: [{before: "", after: nil}]
    }
end
