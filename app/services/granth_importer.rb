# frozen_string_literal: true

require 'csv'

class GranthImporter
  attr_reader :csv_data

  def initialize(csv_file = Rails.root.join('lib/assets/temp_jahaaj.csv').read)
    @blob = CSV.parse(csv_file, :headers => true)
  end

  def execute
    @blob.each do |row|
      # ALL FIELDS
      book_name = row['Book_Name'].try(:strip)
      chapter_name = row['Chapter_Name'].try(:strip)
      chapter_number = row['Chapter_Number'].try(:to_i)
      chhand_name = row['Chhand_Type'].try(:strip)
      tuk = row['Tuk'].try(:strip)
      pauri_number = row['Pauri_Number'].try(:to_i)

      # TODO: When ready, we can import these fields as well!
      # footnotes = row['Footnotes'].try(:strip)
      # extended_ref = row['Extended_Ref'].try(:strip)
      # extended_meaning = row['Extended_Meaning'].try(:strip)
      # translation_en = row['Translation_EN'].try(:strip)

      # BOOK
      @book = Book.find_by(:en_title => book_name)

      # CHAPTER
      create_chapter(chapter_name, chapter_number) if new_chapter?(chapter_number)

      # CHHAND_TYPE
      @chhand_type = ChhandType.find_or_create_by(:name => chhand_name)

      # CHHAND
      create_chhand if new_chhand?(chhand_name)

      # PAURI
      create_pauri(pauri_number) if new_pauri?(pauri_number)

      # TUKS
      create_tuk(tuk)
    end
  end

  private

  def create_chapter(chapter_name, chapter_number)
    @book.chapters.create(:title => chapter_name, :number => chapter_number)
  end

  def create_chhand
    @book.last_chapter.chhands.create(
      :chhand_type_id => @chhand_type.id,
      :sequence => (@book.last_chhand.try(:sequence).to_i + 1) || 1
    )
  end

  def create_pauri(pauri_number)
    @book.last_chhand.pauris.create!(
      :number => pauri_number,
      :chapter => @book.last_chapter
    )
  end

  def create_tuk(tuk)
    @book.last_pauri.tuks.create(
      :chapter => @book.last_chapter,
      :sequence => (@book.last_tuk.try(:sequence).to_i + 1) || 1,
      :content => tuk,
      :original_content => tuk
    )
  end

  def new_chapter?(number)
    return true if @book.last_chapter.nil?
    return @book.last_chapter.number != number
  end

  def new_chhand?(chhand_name)
    return true if @book.last_chapter.nil? # Sometimes chapter might end with the same name
    return true if @book.last_chhand.nil?
    return @book.last_chhand.chhand_type.name != chhand_name
  end

  def new_pauri?(number)
    return true if @book.last_pauri.nil?
    return @book.last_pauri.number != number
  end
end
