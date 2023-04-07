# frozen_string_literal: true

FactoryBot.define do
  factory :tuk_translation do
    en_translation { 'In the same way one cannot kill the sky,' }
    en_translator { 'The Sarbloh Scholar' }
    association :tuk, :factory => :tuk
  end
end
