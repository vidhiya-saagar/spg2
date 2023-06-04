# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :chapters, :dependent => :destroy

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

  def number_of_chapters_released
    return self.chapters.released.count
  end
end
