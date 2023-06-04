# frozen_string_literal: true

class Giani < ApplicationRecord
  has_many :kathas, :dependent => :destroy
end
