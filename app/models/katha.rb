# frozen_string_literal: true

class Katha < ApplicationRecord
  belongs_to :giani
  has_many :chapter_kathas
  has_many :chapters, :through => :chapter_kathas
end
