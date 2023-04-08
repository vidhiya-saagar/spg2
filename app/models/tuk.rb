# frozen_string_literal: true

class Tuk < ApplicationRecord
  belongs_to :chapter
  belongs_to :pauri
  has_one :translation, :class_name => 'TukTranslation', :dependent => :destroy

  validates :sequence, :presence => true
  validates :content, :presence => true
  validates :sequence, :uniqueness => { :scope => :pauri_id }

  before_validation :clean_content

  def clean_content
    return if self.content.blank?
    self.content = self.content
      .gsub(/[\u2070-\u209f\u00b0-\u00be]+/, '') # Remove subscript (exponent)
      .gsub(%r{[`~!@#$%^&*()_|+\-=?;:'",.<>†⚑‘’{}\[\]\\/]}, '') # Remove special characters
      .squeeze(' ') # Replace extra spaces with a single space
      .strip
  end
end
