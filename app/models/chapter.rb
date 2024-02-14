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

  # @brief Generates a formatted chapter description with relevant information and links.
  # @example Generating chapter description
  #   `Book.find(15).chapters.second.copy_paste_info`
  # @return [void]
  def copy_paste_info
    info = <<~HEREDOC
      #{self.title} (#{self.en_title})

      #{self.en_short_summary}

      Discover the uncensored Suraj Prakash and its English translations, summaries, and audio discourse at https://spg.dev/chapters/#{self.id}! Explore Chapter #{self.number} of #{self.book.en_title} now!

      ✍🏽 Explore this chapter:
      https://spg.dev/chapters/#{self.id}

      📖 Explore other chapters in #{self.book.en_title}:
      https://spg.dev/books/#{self.book.en_title.parameterize}

      ☀️ Explore Gurpartap Suraj Granth - Suraj Prakash Granth (SPG)
      https://spg.dev/books
    HEREDOC

    Rails.logger.debug info
  end

  def copy_paste_artwork_alt_text
    info = <<~HEREDOC
      {https://spg.dev/chapters/#{self.id}}

      Artwork for chapter #{self.number} of #{self.book.en_title}, titled: “#{self.en_title}.”

      #{self.en_short_summary}
    HEREDOC

    Rails.logger.debug info
  end

  def csv_rows
    file_path = "lib/imports/#{self.book.sequence}/#{self.number}.csv"

    unless File.exist?(file_path)
      Rails.logger.debug "CSV file #{file_path} not found. " + Pastel.new.red.on_bright_white.bold("Are you sure you added it to #{file_path}?")
      raise "CSV file #{file_path} not found. "
    end

    rows = []
    CSV.foreach(file_path, :headers => true) do |row|
      rows << row
    end
    return rows
  end
end
