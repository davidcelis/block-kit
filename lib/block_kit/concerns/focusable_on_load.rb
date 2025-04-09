# frozen_string_literal: true

module BlockKit
  module Concerns
    module FocusableOnLoad
      extend ActiveSupport::Concern

      included do
        attribute :focus_on_load, :boolean
      end

      def as_json(*)
        super.merge(focus_on_load: focus_on_load).compact
      end
    end
  end
end
