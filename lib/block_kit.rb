# frozen_string_literal: true

require "active_support/core_ext/module/attribute_accessors"

module BlockKit
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

  autoload :Configuration, "block_kit/configuration"
  autoload :VERSION, "block_kit/version"

  mattr_reader :configuration, default: Configuration.new, instance_reader: false, instance_accessor: false

  class << self
    alias_method :config, :configuration
  end

  def self.configure(&block)
    raise ArgumentError, "BlockKit.configure requires a block" unless block_given?

    yield(configuration)
  end

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
