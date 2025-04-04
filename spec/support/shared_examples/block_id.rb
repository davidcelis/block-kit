require "spec_helper"

RSpec.shared_examples_for "a block with a block_id" do
  it "casts block_id to string" do
    subject.block_id = 123
    expect(subject.block_id).to eq("123")
  end

  it "includes `block_id` when serialized and present" do
    expect(subject.as_json).not_to have_key(:block_id)

    subject.block_id = nil
    expect(subject.as_json).not_to have_key(:block_id)

    subject.block_id = "block_id"
    expect(subject.as_json[:block_id]).to eq("block_id")

    # It's weird, but apparently valid.
    subject.block_id = ""
    expect(subject.as_json[:block_id]).to eq("")
  end

  it "validates the length of block_id" do
    expect(subject).to be_valid

    subject.block_id = "a" * 256
    expect(subject).not_to be_valid
    expect(subject.errors[:block_id]).to include("is too long (maximum is 255 characters)")

    subject.block_id = nil
    expect(subject).to be_valid

    subject.block_id = ""
    expect(subject).to be_valid
  end
end
