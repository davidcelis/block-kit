require "spec_helper"

RSpec.shared_examples_for "a multi select" do
  it { is_expected.to have_attribute(:max_selected_items).with_type(:integer) }

  describe "#as_json" do
    it "serializes the max_selected_items in as JSON" do
      subject.max_selected_items = 3

      expect(subject.as_json).to include(max_selected_items: 3)
    end
  end

  it { is_expected.to validate_presence_of(:max_selected_items).allow_nil }
  it { is_expected.not_to allow_value(0).for(:max_selected_items).with_message("must be greater than 0") }
end
