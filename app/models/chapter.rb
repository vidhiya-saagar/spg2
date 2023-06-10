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

  def csv_rows
    file_path = "lib/imports/#{self.book.sequence}/#{self.number}.csv"

    unless File.exist?(file_path)
      puts "CSV file #{file_path} not found. " + Pastel.new.red.on_bright_white.bold("Are you sure you added it to #{file_path}?")
      raise "CSV file #{file_path} not found. "
    end

    rows = []
    CSV.foreach(file_path, :headers => true) do |row|
      rows << row
    end
    return rows
  end
end
