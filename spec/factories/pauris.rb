# frozen_string_literal: true

FactoryBot.define do
  factory :pauri do
    number { rand(1..100) }
    association :chapter, :factory => :chapter
    association :chhand, :factory => :chhand
  end
end
