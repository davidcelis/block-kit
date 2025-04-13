# frozen_string_literal: true

module BlockKit
  module Elements
    class Select < Base
      include Concerns::Confirmable
      include Concerns::FocusableOnLoad
      include Concerns::HasPlaceholder
      include Concerns::PlainTextEmojiAssignment.new(:placeholder)

      def initialize(attributes = {})
        raise NotImplementedError, "#{self.class} is an abstract class and can't be instantiated." if instance_of?(Select)

        super
      end
    end
  end
end
