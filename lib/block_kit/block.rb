# frozen_string_literal: true

module BlockKit
  class Block
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    def as_json(*)
      {type: self.class::TYPE}
    end
  end
end
