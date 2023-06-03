# frozen_string_literal: true

json.key_format! :camelize => :lower

json.chapters do
  json.array!(@chapters, :id, :number, :title, :en_title, :en_long_summary, :en_short_summary, :artwork_url)
end
