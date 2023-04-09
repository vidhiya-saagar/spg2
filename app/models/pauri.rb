# frozen_string_literal: true

class Pauri < ApplicationRecord
  belongs_to :chapter
  belongs_to :chhand
  has_one :translation, :class_name => 'PauriTranslation', :dependent => :destroy
  has_many :tuks, :dependent => :destroy
end
