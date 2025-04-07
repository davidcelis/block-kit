# frozen_string_literal: true

require "spec_helper"

# This block expects the user to declare `valid_associations` and `invalid_associations`
# in the context of the block.
RSpec.shared_examples_for "a block that validates an associated block" do |attribute, allow_nil: false|
  it "validates the associated block" do
    invalid_associations.each do |associated, message|
      subject.public_send(:"#{attribute}=", associated)
      expect(subject).not_to be_valid
      expect(subject.errors[attribute]).to include("is invalid: #{message}")
    end

    valid_associations.each do |associated|
      subject.public_send(:"#{attribute}=", associated)
      expect(subject).to be_valid
    end
  end
end
