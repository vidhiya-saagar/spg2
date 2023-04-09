# frozen_string_literal: true

class Chhand < ApplicationRecord
  belongs_to :chhand_type
  belongs_to :chapter
  has_many :pauris, :dependent => :destroy

  validates :sequence, :presence => true
  validates :sequence, :uniqueness => { :scope => :chapter_id }
end
