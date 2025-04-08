require "spec_helper"

RSpec.shared_examples_for "a block that is confirmable" do
  it { is_expected.to have_attribute(:confirm).with_type(:block_kit_confirmation_dialog) }
  it { is_expected.to validate_presence_of(:confirm).allow_nil }

  it "validates the associated confirmation dialog" do
    subject.confirm = BlockKit::Composition::ConfirmationDialog.new(
      title: "",
      text: "Dialog Text",
      confirm: "Yes",
      deny: "No"
    )

    expect(subject).not_to be_valid
    expect(subject.errors[:confirm]).to include("is invalid: title can't be blank")
  end

  it "serializes the associated confirmation dialog when converting to JSON" do
    expect(subject.as_json).not_to have_key(:confirm)

    subject.confirm = {title: "Dialog Title", text: "Dialog Text", confirm: "Yes", deny: "No"}

    expect(subject.as_json[:confirm]).to eq({
      title: {type: "plain_text", text: "Dialog Title"},
      text: {type: "plain_text", text: "Dialog Text"},
      confirm: {type: "plain_text", text: "Yes"},
      deny: {type: "plain_text", text: "No"}
    })
  end
end
