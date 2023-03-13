# frozen_string_literal: true

# # frozen_string_literal: true

FactoryBot.define do
  factory :chapter do
    book
    number { '1' }
    title { 'Chapter' }
    en_title { '' }
    en_short_summary { '' }
    en_long_summary { '' }
    samapati { '' }
    en_samapati { '' }
    artwork_url { '' }
  end
end
