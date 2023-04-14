# frozen_string_literal: true

class Pauri < ApplicationRecord
  belongs_to :chapter
  belongs_to :chhand
  has_one :translation, :class_name => 'PauriTranslation', :dependent => :destroy
  has_one :external_pauri, :dependent => :destroy
  has_many :tuks, :dependent => :destroy

  validates :number, :uniqueness => { :scope => :chapter_id }
end
