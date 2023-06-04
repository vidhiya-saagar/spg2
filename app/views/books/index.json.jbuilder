# frozen_string_literal: true

json.key_format! :camelize => :lower

json.books do
  json.array!(@books, :id, :sequence, :title, :en_title, :en_short_summary, :en_synopsis, :artwork_url, :number_of_chapters_released)
end
