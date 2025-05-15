# frozen_string_literal: true

require "active_support/configurable"

module BlockKit
  include ActiveSupport::Configurable

  autoload :Base, "block_kit/base"
  autoload :Blocks, "block_kit/blocks"
  autoload :Composition, "block_kit/composition"
  autoload :Concerns, "block_kit/concerns"
  autoload :Elements, "block_kit/elements"
  autoload :Fixers, "block_kit/fixers"
  autoload :Layout, "block_kit/layout"
  autoload :Surfaces, "block_kit/surfaces"
  autoload :TypedArray, "block_kit/typed_array"
  autoload :TypedSet, "block_kit/typed_set"
  autoload :Types, "block_kit/types"
  autoload :Validators, "block_kit/validators"

  autoload :VERSION, "block_kit/version"

  def self.blocks(attributes = {}, &block)
    Blocks.new(attributes, &block)
  end

  def self.home(attributes = {}, &block)
    Surfaces::Home.new(attributes, &block)
  end

  def self.modal(attributes = {}, &block)
    Surfaces::Modal.new(attributes, &block)
  end

  def self.message(attributes = {}, &block)
    Surfaces::Message.new(attributes, &block)
  end
end
