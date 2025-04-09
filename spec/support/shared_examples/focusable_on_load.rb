require "spec_helper"

RSpec.shared_examples_for "a block that is focusable on load" do
  it { is_expected.to have_attribute(:focus_on_load).with_type(:boolean) }

  it "includes `focus_on_load` when serialized and present" do
    expect(subject.as_json).not_to have_key(:focus_on_load)
    subject.focus_on_load = false
    expect(subject.as_json[:focus_on_load]).to be false
  end
end
