# frozen_string_literal: true

json.key_format! :camelize => :lower

json.chapter do
  # :chapter => {:id, :number, :title, :en_title, :en_short_summary, :en_long_summary, :artwork_url}
  json.call(@chapter, :id, :book_id, :number, :title, :en_title, :en_long_summary, :en_short_summary, :artwork_url)
end
