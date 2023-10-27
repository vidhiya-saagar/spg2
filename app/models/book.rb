# frozen_string_literal: true

require 'csv'
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

  ##
  # Create (or update) the a specific chapter via CSV
  # HOW IT WORKS:
  # 1. Add your CSV file to `lib/imports/#{book.sequence}/#{chapter_number}.csv`
  # 2. Pass in a `chapter_number: Integer` e.g. `3`
  # 3. Call `@book.import_chapter(3)`.
  # EXAMPLE:
  #   @book = Book.find_by(:sequence => 1)
  #   @book.import_chapter(3)
  #   This will search for a CSV file at `lib/imports/1/3.csv` (or raise error)
  # The CSV file should have the following columns:
  # - Chapter_Number: Integer
  # - Chapter_Name: String
  # - Chhand_Type: String
  # - Tuk: String
  # - Pauri_Number: Integer
  # - Tuk_Number: Integer
  # - Pauri_Translation_EN: String | NULL
  # - Tuk_Translation_EN: String | NULL
  # - Footnotes: String | NULL
  # - Extended_Ref: String | NULL
  # - Assigned_Singh: String | NULL
  # - Extended_Meaning: String | NULL
  ##
  def import_chapter(chapter_number)
    ChapterImporterService.new(self, chapter_number).call
  end
end
