# frozen_string_literal: true

class Katha < ApplicationRecord
  belongs_to :giani, :optional => true
  has_one :chapter_katha, :dependent => :destroy
  has_one :chapter, :through => :chapter_katha, :dependent => :destroy
end
