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

  def self.blocks(&block)
    Blocks.new(&block)
  end

  def self.home(&block)
    Surfaces::Home.new(&block)
  end

  def self.modal(&block)
    Surfaces::Modal.new(&block)
  end

  def self.message(&block)
    Surfaces::Message.new(&block)
  end
end
