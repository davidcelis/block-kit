# This matcher checks if an object or its class has a specific attribute.
#
# Example usage:
# expect(block).to have_attribute(:block_id)
# expect(BlockKit::Blocks::Section).to have_attribute(:text).with_type(:text_block)
# expect(BlockKit::Blocks::Header).to have_attribute(:text).with_type(:plain_text_block)
RSpec::Matchers.define :have_attribute do |attribute_name|
  define_method :get_class do |object|
    object.is_a?(Class) ? object : object.class
  end

  define_method :get_active_model_type do |responder|
    responder.respond_to?(:attribute_types) && responder.attribute_types[attribute_name.to_s]
  end

  match do |object|
    responder = get_class(object)
    active_model_type = get_active_model_type(responder)

    next active_model_type unless @expected_type

    @actual_type = active_model_type.type
    @actual_item_types = []

    if @expected_item_types
      @actual_item_types = if @expected_type == :block_kit_block
        active_model_type.block_types
      elsif active_model_type.item_type.type == :block_kit_block
        active_model_type.item_type.block_classes
      else
        [active_model_type.item_type]
      end

      @actual_item_types = @actual_item_types.map do |item_type|
        if item_type.is_a?(Class) && item_type < BlockKit::Base
          :"block_kit_#{item_type.type}"
        else
          item_type.type
        end
      end
    end

    if defined?(@expected_default_value)
      @actual_default_value = described_class.new.public_send(attribute_name)
    end

    @expected_type == @actual_type &&
      (@expected_item_types.nil? || @expected_item_types.sort == @actual_item_types.sort) &&
      @expected_default_value == @actual_default_value
  end

  chain :with_type do |expected_type|
    @expected_type = expected_type
  end

  chain :containing do |*item_types|
    raise ArgumentError, "can't chain `with_type' and `containing' when `with_type' is not `:array', `:set', or `:block_kit_block`" unless @expected_type.in?(%i[array set block_kit_block])

    @expected_item_types = item_types
  end

  chain :with_default_value do |default_value|
    @expected_default_value = default_value
  end

  failure_message do |object|
    responder = get_class(object)
    active_model_type = get_active_model_type(responder)

    message = "expected #{responder} to have attribute `#{attribute_name}'"
    message += " with type `#{@expected_type}'" if @expected_type
    message += " containing `#{@expected_item_types}'" if @expected_item_types
    message += " with default value `#{@expected_default_value}'" if defined?(@expected_default_value)

    message += if active_model_type.present?
      msg = ", but its type is `#{@actual_type}'"
      msg += " containing `#{@actual_item_types}'" if @actual_item_types
      msg += " and default value `#{@actual_default_value}'" if @actual_default_value
      msg
    else
      ", but it doesn't"
    end

    message
  end

  failure_message_when_negated do |object|
    responder = get_class(object)

    message = "expected #{responder} not to have attribute `#{attribute_name}'"
    message += " with type `#{@expected_type}'" if @expected_type
    message += " containing `#{@expected_item_types}'" if @expected_item_types
    message += ", but it does"

    message
  end
end
