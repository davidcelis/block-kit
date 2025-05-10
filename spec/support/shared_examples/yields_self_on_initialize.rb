# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples_for "a class that yields self on initialize" do
  it "yields self" do
    expect { |b| described_class.new(&b) }.to yield_with_args(described_class)
  end

  it "yields self when other args are passed" do
    attribute = described_class.attribute_types.keys.sample

    expect { |b| described_class.new(attribute => nil, &b) }.to yield_with_args(described_class)
  end
end
