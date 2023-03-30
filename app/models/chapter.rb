# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :book
  has_many :chhands, :dependent => :destroy
end
