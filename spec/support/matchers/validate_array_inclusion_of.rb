require "securerandom"

# This matcher works like `shoulda-matchers`'s `validate_inclusion_of`, but for
# array attributes. It ensures that elements in the provided array are valid to
# be included in the attribute, while allowing `blank` (empty array) or `nil`
# values if chained.
#
# Example usage:
#
#   it { is_expected.to validate_array_inclusion_of(:trigger_actions_on).in_array(%w[message_action block_actions]) }
#   it { is_expected.to validate_array_inclusion_of(:include).in_array(%w[im mpim public private]).allow_nil }
#   it { is_expected.to validate_array_inclusion_of(:style).in_array(%w[primary danger]).allow_nil }
RSpec::Matchers.define :validate_array_inclusion_of do |attribute_name|
  chain :in_array do |array|
    @array = array
  end

  chain :allow_nil do
    @allow_nil = true
  end

  chain :allow_blank do
    @allow_blank = true
  end

  chain :with_arbitrary_outside_value do |value|
    @arbitrary_outside_value = value
  end

  match do |model|
    model.assign_attributes(attribute_name => @array)
    @array_is_valid = model.valid?

    # Test that an arbitrary value outside the array is invalid
    @arbitrary_outside_value ||= SecureRandom.hex(64)
    model.assign_attributes(attribute_name => [*@array, @arbitrary_outside_value])
    @arbitrary_outside_value_is_invalid = !model.valid?

    if @allow_nil
      model.assign_attributes(attribute_name => nil)
      @nil_is_valid = model.valid?
    end

    if @allow_blank
      model.assign_attributes(attribute_name => [])
      @blank_is_valid = model.valid?
    end

    @array_is_valid &&
      @arbitrary_outside_value_is_invalid &&
      (@nil_is_valid || !@allow_nil) &&
      (@blank_is_valid || !@allow_blank)
  end

  failure_message do |model|
    message = "expected #{model.class} to validate that attribute `#{attribute_name}` can only include values in the array `#{@array.inspect}`"
    message << ", or be empty" if @allow_blank
    message << ", or be nil" if @allow_nil
    message << ", but it did not:\n\n"
    message << "  - expected attribute `#{attribute_name}` to be valid with value `#{@value}`, but it was not\n" unless @array_is_valid
    message << "  - expected attribute `#{attribute_name}` to be valid with value `nil`, but it was not\n" if @allow_nil && !@nil_is_valid
    message << "  - expected attribute `#{attribute_name}` to be valid with value `[]`, but it was not\n" if @allow_blank && !@blank_is_valid
    message << "  - expected attribute `#{attribute_name}` to be invalid with a value not present in the array, but it was (arbitrary value: #{@arbitrary_outside_value})" unless @arbitrary_outside_value_is_invalid

    message
  end
end
