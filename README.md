# Block Kit

`block-kit` is a Ruby library for Slack's [Block Kit](https://api.slack.com/block-kit) framework built on ActiveModel, providing a powerful DSL for building surfaces like modals, home tabs, messages, or even just blocks themselves.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add block-kit
```

Or just install it globally:

```bash
gem install block-kit
```

## Usage

Blocks can be built individually or as a surface or collection of blocks, which each block able to initialize with a simple Hash or attributes or via a block-based DSL. For example, each of the following declarations would result in the same `section` block:

```ruby
require "block-kit"

section = BlockKit::Layout::Section.new(text: BlockKit::Composition::Mrkdwn.new(text: "Hello, world!"))
section = BlockKit::Layout::Section.new(text: "Hello, world!")
section = BlockKit::Layout::Section.new do |s|
  # With one of any of the following:
  s.mrkdwn(text: "Hello, world!")
  s.text("Hello, world!")
  s.text = BlockKit::Composition::Mrkdwn.new(text: "Hello, world!")
  s.text = {type: "mrkdwn", text: "Hello, world!"}
  s.text = "Hello, world!" # Defaults to `mrkdwn` for section blocks
end
```

Because each block is built using ActiveModel, attributes are cast to their appropriate types from a variety of inputs. If a block contains another block, you can even assign that nested block as a Hash, which means you should be able to completely reconstruct views or messages from the JSON they serialize to. Additionally, like other ActiveModel classes, values that cannot be cast simply result in `nil`, including when you attempt to do something like add an element to a block that doesn't support it.

ActiveModel and the extensive DSL provides a powerful and flexible way to build UI in Slack. Here's an end-to-end example of building a message and a modal and sending them to Slack:

```ruby
require "slack-ruby-client"
require "block-kit"

footer = BlockKit::Layout::Context.new do |c|
  c.mrkdwn(text: "_Made with :heart: in Portland, OR_")
end

# Or `BlockKit::Blocks.new do |b|`
blocks = BlockKit.blocks do |b|
  b.header(text: "Hello, :earth_americas:!", emoji: true)

  b.divider

  b.section(block_id: "content") do |s|
    s.mrkdwn(text: "Welcome to Block Kit!")
    s.button(text: "Learn more", style: "primary", url: "https://api.slack.com/block-kit")
  end

  b.append(footer)
end

client = Slack::Web::Client.new
client.chat_postMessage(
  channel: "#general",
  blocks: blocks.to_json,
  text: "Hello, world!"
)

modal = BlockKit.modal(blocks: blocks) do |m|
  m.title(text: "Hello, :earth_americas:!", emoji: true)
  m.close(text: "Close", emoji: true)
end

client.views_open(
  trigger_id: "trigger_id",
  view: modal.to_json
)
```

Most DSL methods you call while building blocks will accept optional keyword arguments for the block's attributes and will yield the block itself, allowing you to choose how you want to build your blocks.

Another benefit of being built on ActiveModel is that all documented limitations of BlockKit are enforced as model validations, with surfaces and collections validating all blocks within them. For example:

```ruby
modal = BlockKit.modal do |m|
  m.title(text: "Hello, world! Welcome to Block Kit!")

  m.section(block_id: "content") do |s|
    s.mrkdwn(text: "Welcome to Block Kit!")
    s.button(text: "Learn more", style: "primary", url: "invalid.url")
  end

  m.append(footer)
end

modal.valid?
# => false

modal.errors.full_messages
["Blocks is invalid", "Blocks[0] is invalid: accessory.url is not a valid URI", "Title is too long (maximum is 24 characters)"]
```

This allows you to catch most issues that would result in an `invalid_blocks` error from Slack before you even send the request. Better yet, `block-kit` provides a way to fix any validation error that wouldn't result in changing the behavior of your view. For instance:

```ruby
modal = BlockKit.modal do |m|
  m.title(text: "Hello, world! Welcome to Block Kit!")

  m.section(block_id: "content") do |s|
    s.mrkdwn(text: "Welcome to Block Kit!")
    s.button(text: "Learn more", style: "", url: "https://api.slack.com/block-kit")
  end

  m.append(footer)
end

modal.valid?
# => false

modal.errors.full_messages
# => ["Blocks is invalid", "Blocks[0] is invalid: accessory.style can't be blank", "Title is too long (maximum is 24 characters)"]

modal.fix_validation_errors
# => true # or false if any errors couldn't be fixed

modal.title
# => #<BlockKit::Composition::PlainText text: "Hello, world! Welcome...", emoji: nil>

modal.blocks.first.accessory
# => #<BlockKit::Elements::Button text: #<BlockKit::Composition::PlainText text: "Learn more", emoji: nil>, style: nil, ...>
```

The gem can also be configured to fix validation errors automatically on validation or when rendering as JSON if you don't want to have to remember to call `fix_validation_errors` yourself:

```ruby
BlockKit.configure do |config|
  # You can set both of these, but `autofix_on_render` is likely enough if you
  # prefer not to have to call `valid?` at all. Note that `autofix_on_render`
  # does _not_ mean that only the resulting JSON is fixed; it still fixes the
  # underlying model's attributes, meaning the model will be mutated.
  config.autofix_on_validation = true
  config.autofix_on_render = true

  # Set this to perform autofixes that may change the behavior of your view. This
  # is useful if you would rather post messages or publish views at the cost of
  # behavioral quirks or changes rather than suffer from `invalid_blocks` errors.
  #
  # If you'd prefer to run dangerous autofixers on demand, you can do this by
  # calling `fix_validation_errors(dangerous: true)` on your blocks or surfaces.
  config.autofix_dangerously = true
end
```

Autofixers currently include:

* Truncating long text fields to their maximum length
* Setting optional attributes to `nil` if they are blank

Dangerous autofixers (which can be run by calling `fix_validation_errors(dangerous: true)`) that may change the behavior of your view include:

* Truncating long _lists_ of blocks or elements to their maximum length (such as surface blocks, options, option groups, actions elements, etc.)
* Truncating URLs to their maximum length
* Removing section accessories or actions/input elements from surfaces that don't support them

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidcelis/block-kit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/davidcelis/block-kit/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Block::Kit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/davidcelis/block-kit/blob/main/CODE_OF_CONDUCT.md).
