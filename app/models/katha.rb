# frozen_string_literal: true

class Katha < ApplicationRecord
  belongs_to :giani
  has_many :chapter_kathas, :dependent => :destroy
  has_many :chapters, :through => :chapter_kathas, :dependent => :destroy
end
