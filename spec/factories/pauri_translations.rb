# frozen_string_literal: true

FactoryBot.define do
  factory :pauri_translation do
    en_translation { 'In this pauri...' }
    en_translator { 'SikhTranslations' }
    association :pauri, :factory => :pauri
  end
end
