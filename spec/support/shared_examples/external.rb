require "spec_helper"

RSpec.shared_examples_for "an external select" do
  it { is_expected.to have_attribute(:min_query_length).with_type(:integer) }

  describe "#as_json" do
    it "serializes the min_query_length in as JSON" do
      subject.min_query_length = 3

      expect(subject.as_json).to include(min_query_length: 3)
    end
  end

  it { is_expected.to validate_presence_of(:min_query_length).allow_nil }

  it { is_expected.to allow_value(1).for(:min_query_length) }
  it { is_expected.to allow_value(0).for(:min_query_length) }
  it { is_expected.not_to allow_value(-1).for(:min_query_length).with_message("must be greater than or equal to 0") }
end
