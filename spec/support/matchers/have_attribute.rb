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

  define_method :get_attribute do |responder|
    responder.respond_to?(:attribute_types) && responder.attribute_types[attribute_name.to_s]
  end

  match do |object|
    responder = get_class(object)
    attribute = get_attribute(responder)

    next !!attribute unless @expected_type

    attribute.type == @expected_type && (@item_types.nil? || (attribute.type == :array && attribute.item_types.map(&:type).sort == @item_types.sort))
  end

  chain :with_type do |expected_type|
    @expected_type = expected_type
  end

  chain :containing do |*item_types|
    raise ArgumentError, "Cannot chain `with_type' and `containing' when `with_type' is not `:array'" unless @expected_type == :array

    @item_types = item_types
  end

  failure_message do |object|
    responder = get_class(object)
    attribute = get_attribute(responder)

    message = "expected #{responder} to have attribute `#{attribute_name}'"
    message += " with type `#{@expected_type}'" if @expected_type
    message += " containing `#{@item_types}'" if @item_types

    message += if attribute.present?
      ", but it's type is `#{attribute.type}'#{" containing `#{attribute.item_types.map(&:type)}'" if @item_types}"
    else
      ", but it doesn't"
    end

    message
  end

  failure_message_when_negated do |object|
    responder = get_class(object)

    message = "expected #{responder} not to have attribute `#{attribute_name}'"
    message += " with type `#{@expected_type}'" if @expected_type
    message += " containing `#{@item_types}'" if @item_types
    message += ", but it does"

    message
  end
end
