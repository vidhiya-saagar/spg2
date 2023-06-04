# frozen_string_literal: true

json.key_format! :camelize => :lower

json.book do
  # :book => {:id, :sequence, :title, :enTitle, :enShortSummary, :enSynopsis, :artworkUrl, :numberOfChaptersReleased }
  json.call(@book, :id, :sequence, :title, :en_title, :en_short_summary, :en_synopsis, :artwork_url, :number_of_chapters_released)
end
