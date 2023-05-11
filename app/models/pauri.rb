# frozen_string_literal: true

class Pauri < ApplicationRecord
  belongs_to :chapter
  belongs_to :chhand
  has_one :translation, :class_name => 'PauriTranslation', :dependent => :destroy
  has_one :external_pauri, :dependent => :destroy
  has_many :tuks, :dependent => :destroy
  has_one :footnote, :class_name => 'PauriFootnote', :dependent => :destroy

  validates :number, :uniqueness => { :scope => :chapter_id }
  validates :number, :presence => true
  validates :number, :numericality => { :greater_than => 0 }
end
