# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :chapters, :dependent => :destroy

  # @brief Returns the released chapters for the book.
  #
  # A chapter is considered "released" if it has an `artwork_url`.
  # @return [ActiveRecord::Relation] Set of released chapters.
  def released_chapters
    return self.chapters.where.not(:artwork_url => nil)
  end

  def last_chapter
    return self.chapters.last
  end

  def last_chhand
    return last_chapter.chhands.last
  end

  def last_pauri
    return last_chhand.pauris.last
  end

  def last_tuk
    return last_pauri.tuks.last
  end
end
