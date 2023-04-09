# frozen_string_literal: true

require 'csv'

class GranthImporter
  attr_reader :csv_data

  def initialize(csv_file = Rails.root.join('lib/assets/temp_jahaaj.csv').read)
    @blob = CSV.parse(csv_file, :headers => true)
  end

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
