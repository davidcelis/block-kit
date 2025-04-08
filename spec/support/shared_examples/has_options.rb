require "spec_helper"

RSpec.shared_examples_for "a block that has options" do |with_limit:|
  it { is_expected.to have_attribute(:options).with_type(:array, :block_kit_option) }

  it "validates that options are present" do
    subject.options = nil
    expect(subject).not_to be_valid
    expect(subject.errors[:options]).to include("can't be blank")

    subject.options = []
    expect(subject).not_to be_valid
    expect(subject.errors[:options]).to include("can't be blank")
  end

  it "validates that there can be at most #{with_limit} options" do
    subject.options = Array.new(with_limit + 1) { {text: "Option", value: "value"} }
    expect(subject).not_to be_valid
    expect(subject.errors[:options]).to include("is too long (maximum is #{with_limit} options)")
  end

  it "validates the associated options themselves" do
    subject.options = [{text: "Option 1", value: ""}]
    expect(subject).not_to be_valid
    expect(subject.errors["options[0]"]).to include("is invalid: value can't be blank")
  end
end
