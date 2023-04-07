# frozen_string_literal: true

FactoryBot.define do
  factory :tuk do
    add_attribute(:sequence) { '1' }
    original_content { ' ਏਕੁੰਕਾਰਾ¹' }
    content { 'ਏਕੁੰਕਾਰਾ' }
    association :pauri, :factory => :pauri
    association :chapter, :factory => :chapter
  end
end
