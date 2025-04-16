require "spec_helper"

RSpec.shared_examples_for "a block with a block_id" do
  it { is_expected.to have_attribute(:block_id).with_type(:string) }

  it "includes `block_id` when serialized and present" do
    subject.block_id = nil
    expect(subject.as_json).not_to have_key(:block_id)

    subject.block_id = "block_id"
    expect(subject.as_json[:block_id]).to eq("block_id")
  end

  it { is_expected.to validate_length_of(:block_id).is_at_most(255).allow_nil }

  it_behaves_like "a block that fixes validation errors", attribute: :block_id, null_value: {
    valid_values: ["anything", nil],
    invalid_values: [{before: "", after: nil}]
  }
end
