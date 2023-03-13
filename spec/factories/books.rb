# frozen_string_literal: true

# # frozen_string_literal: true

FactoryBot.define do
  factory :book do
    add_attribute(:sequence) { '1' }
    title { 'Gurpratap Suraj - Suraj Prakash Granth' }
    en_title { 'SPG' }
    en_short_summary { 'The glorious!' }
    en_synopsis { '' }
    artwork_url { '' }
  end
end
