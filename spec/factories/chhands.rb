# frozen_string_literal: true

FactoryBot.define do
  factory :chhand do
    association :chhand_type
    association :chapter
  end
end
