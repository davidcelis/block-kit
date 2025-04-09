# This matcher checks if an object or its class has a specific attribute.
#
# Example usage:
# expect(block).to alias_attribute(:initial_date_time).as(:initial_datetime)
# expect(BlockKit::Elements::PlainTextInput).to alias_attribute(:dispatch_action_config).as(:dispatch_action_configuration)
RSpec::Matchers.define :alias_attribute do |attribute_name|
  define_method :get_class do |object|
    object.is_a?(Class) ? object : object.class
  end

  define_method :get_aliases do |responder|
    responder.respond_to?(:attribute_aliases) && responder.attribute_aliases.select { |_, v| v == attribute_name.to_s }
  end

  chain :as do |expected_alias|
    @expected_alias = expected_alias
  end

  match do |object|
    responder = get_class(object)
    attribute_aliases = get_aliases(responder)
    attribute_aliases = attribute_aliases.select { |k, _| k == @expected_alias.to_s } if @expected_alias

    attribute_aliases.any?
  end

  failure_message do |object|
    responder = get_class(object)
    aliasas = get_aliases(responder)

    message = "expected #{responder} to have aliased the attribute `#{attribute_name}'"
    message += " to `#{@expected_alias}'" if @expected_alias
    message += if aliasas.any?
      ", but it is only aliased to: #{aliasas.values.join(", ")}"
    else
      ", but it doesn't"
    end

    message
  end

  failure_message_when_negated do |object|
    responder = get_class(object)
    aliasas = get_aliases(responder)

    message = "expected #{responder} not to have aliased attribute `#{attribute_name}'"
    message += " to `#{@expected_alias}'" if @expected_alias
    message += if @expected_alias
      ", but it does"
    else
      ", but it is aliased to: #{aliasas.values.join(", ")}"
    end

    message
  end
end
