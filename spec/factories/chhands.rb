# frozen_string_literal: true

FactoryBot.define do
  factory :chhand do
    association :chhand_type
    association :chapter
    add_attribute(:sequence) { '1' }
  end
end
