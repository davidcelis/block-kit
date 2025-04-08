require "spec_helper"

RSpec.shared_examples_for "a block with required attributes" do |*required_attributes|
  it "raises an error when missing required attributes" do
    expect { described_class.new }.to raise_error(ArgumentError, "missing required attributes: #{required_attributes.join(", ")}")
  end
end
