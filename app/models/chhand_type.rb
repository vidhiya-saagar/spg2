# frozen_string_literal: true

class ChhandType < ApplicationRecord
  has_many :chhands, :dependent => :destroy

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
