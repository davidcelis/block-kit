# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Elements::BaseButton do
  it "raises NotImplementedError when instantiated directly" do
    expect { described_class.new }.to raise_error(NotImplementedError, "#{described_class} is an abstract class and can't be instantiated.")
  end
end
