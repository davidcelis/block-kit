# frozen_string_literal: true

module BlockKit
  module Composition
    class Mrkdwn < Text
      TYPE = "mrkdwn"

      attribute :verbatim, :boolean

      def as_json(*)
        super.merge(verbatim: verbatim).compact
      end
    end
  end
end
