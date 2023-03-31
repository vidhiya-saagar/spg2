# frozen_string_literal: true

class ChhandType < ApplicationRecord
  has_many :chhands, :dependent => :destroy
end
