# frozen_string_literal: true

class Pauri < ApplicationRecord
  belongs_to :chapter
  has_one :translation, :class_name => 'pauri_translation', :dependent => :destroy
end
