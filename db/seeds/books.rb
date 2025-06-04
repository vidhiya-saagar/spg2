# frozen_string_literal: true

# This file contains the list of all Books in the system
# Each Book record should have a unique ID, sequence number, and titles in both Punjabi and English
# To add a new Book, add a new entry to the BOOKS array below

BOOKS = [
  {
    :id => 1,
    :sequence => 1,
    :title => 'ਸ੍ਰੀ ਨਾਨਕ ਪ੍ਰਕਾਸ਼ ਪੂਰਬਾਰਧ',
    :en_title => 'Sri Nanak Parkash 1'
  },
  {
    :id => 2,
    :sequence => 2,
    :title => 'ਸ੍ਰੀ ਨਾਨਕ ਪ੍ਰਕਾਸ਼ ਉੱੱਤਰਾਰਧ',
    :en_title => 'Sri Nanak Parkash 2'
  },
  {
    :id => 3,
    :sequence => 3,
    :title => 'ਰਾਸਿ ੧',
    :en_title => 'Raas 1'
  },
  {
    :id => 4,
    :sequence => 4,
    :title => 'ਰਾਸਿ ੨',
    :en_title => 'Raas 2'
  },
  {
    :id => 5,
    :sequence => 5,
    :title => 'ਰਾਸਿ ੩',
    :en_title => 'Raas 3'
  },
  {
    :id => 6,
    :sequence => 6,
    :title => 'ਰਾਸਿ ੪',
    :en_title => 'Raas 4'
  },
  {
    :id => 7,
    :sequence => 7,
    :title => 'ਰਾਸਿ ੫',
    :en_title => 'Raas 5'
  },
  {
    :id => 8,
    :sequence => 8,
    :title => 'ਰਾਸਿ ੬',
    :en_title => 'Raas 6'
  },
  {
    :id => 9,
    :sequence => 9,
    :title => 'ਰਾਸਿ ੭',
    :en_title => 'Raas 7'
  },
  {
    :id => 10,
    :sequence => 10,
    :title => 'ਰਾਸਿ ੮',
    :en_title => 'Raas 8'
  },
  {
    :id => 11,
    :sequence => 11,
    :title => 'ਰਾਸਿ ੯',
    :en_title => 'Raas 9'
  },
  {
    :id => 12,
    :sequence => 12,
    :title => 'ਰਾਸਿ ੧੦',
    :en_title => 'Raas 10'
  },
  {
    :id => 13,
    :sequence => 13,
    :title => 'ਰਾਸਿ ੧੧',
    :en_title => 'Raas 11'
  },
  {
    :id => 14,
    :sequence => 14,
    :title => 'ਰਾਸਿ ੧੨',
    :en_title => 'Raas 12'
  },
  {
    :id => 15,
    :sequence => 15,
    :title => 'ਰੁਤਿ ੧',
    :en_title => 'Rut 1'
  },
  {
    :id => 16,
    :sequence => 16,
    :title => 'ਰੁਤਿ ੨',
    :en_title => 'Rut 2'
  },
  {
    :id => 17,
    :sequence => 17,
    :title => 'ਰੁਤਿ ੩',
    :en_title => 'Rut 3'
  },
  {
    :id => 18,
    :sequence => 18,
    :title => 'ਰੁਤਿ ੪',
    :en_title => 'Rut 4'
  },
  {
    :id => 19,
    :sequence => 19,
    :title => 'ਰੁਤਿ ੫',
    :en_title => 'Rut 5'
  },
  {
    :id => 20,
    :sequence => 20,
    :title => 'ਰੁਤਿ ੬',
    :en_title => 'Rut 6'
  },
  {
    :id => 21,
    :sequence => 21,
    :title => 'ਅਯਨ ੧',
    :en_title => 'Ayaan 1'
  },
  {
    :id => 22,
    :sequence => 22,
    :title => 'ਅਯਨ ੨',
    :en_title => 'Ayaan 2'
  }
].freeze

# Create Books if they don't exist
BOOKS.each do |book_data|
  Book.find_or_create_by!(:id => book_data[:id]) do |book|
    book.sequence = book_data[:sequence]
    book.title = book_data[:title]
    book.en_title = book_data[:en_title]
  end
end
