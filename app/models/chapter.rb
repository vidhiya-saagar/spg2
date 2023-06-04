# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :book
  has_many :chhands, :dependent => :destroy
  has_many :pauris, :dependent => :destroy
  has_many :tuks, :through => :pauris
  has_many :chapter_kathas, :dependent => :destroy
  has_many :kathas, :through => :chapter_kathas

  # @brief Returns the released chapters for the book.
  # This is a temporary way to feature gate unreleased chapters.
  # @example `@chapters = Chapter.released.find(...)`
  # @return [ActiveRecord::Relation] Set of released chapters.
  if Rails.env.production?
    scope :released, -> { where.not(:artwork_url => nil) }
  else
    scope :released, -> { all }
  end
end
