# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :book
  has_many :chhands, :dependent => :destroy
  has_many :pauris, :dependent => :destroy
  has_many :tuks, :through => :pauris

  def csv_rows
    file_path = "lib/imports/#{self.book.sequence}/#{self.number}.csv"
    raise "CSV file #{file_path} not found" unless File.exist?(file_path)

    rows = []
    CSV.foreach(file_path, :headers => true) do |row|
      rows << row
    end
    return rows
  end
end
