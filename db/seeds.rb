# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])

# Character.create(:name => 'Luke', :movie => movies.first)

Book.create!(
  [
    {
      :id => 1,
      :sequence => 1,
      :title => 'ਸ੍ਰੀ ਨਾਨਕ ਪ੍ਰਕਾਸ਼ ਪੂਰਬਾਰਧ',
      :en_title => 'Sri Nanak Parkash 1'
    },
    {
      :id => 2,
      :sequence => 2,
      :title => 'ਸ੍ਰੀ ਨਾਨਕ ਪ੍ਰਕਾਸ਼ ਉੱੱਤਰਾਰਧ',
      :en_title => 'Sri Nanak Parkash 2'
    },
    {
      :id => 3,
      :sequence => 3,
      :title => 'ਰਾਸਿ ੧',
      :en_title => 'Raas 1'
    },
    {
      :id => 4,
      :sequence => 4,
      :title => 'ਰਾਸਿ ੨',
      :en_title => 'Raas 2'
    },
    {
      :id => 5,
      :sequence => 5,
      :title => 'ਰਾਸਿ ੩',
      :en_title => 'Raas 3'
    },
    {
      :id => 6,
      :sequence => 6,
      :title => 'ਰਾਸਿ ੪',
      :en_title => 'Raas 4'
    },
    {
      :id => 7,
      :sequence => 7,
      :title => 'ਰਾਸਿ ੫',
      :en_title => 'Raas 5'
    },
    {
      :id => 8,
      :sequence => 8,
      :title => 'ਰਾਸਿ ੬',
      :en_title => 'Raas 6'
    },
    {
      :id => 9,
      :sequence => 9,
      :title => 'ਰਾਸਿ ੭',
      :en_title => 'Raas 7'
    },
    {
      :id => 10,
      :sequence => 10,
      :title => 'ਰਾਸਿ ੮',
      :en_title => 'Raas 8'
    },
    {
      :id => 11,
      :sequence => 11,
      :title => 'ਰਾਸਿ ੯',
      :en_title => 'Raas 9'
    },
    {
      :id => 12,
      :sequence => 12,
      :title => 'ਰਾਸਿ ੧੦',
      :en_title => 'Raas 10'
    },
    {
      :id => 13,
      :sequence => 13,
      :title => 'ਰਾਸਿ ੧੧',
      :en_title => 'Raas 11'
    },
    {
      :id => 14,
      :sequence => 14,
      :title => 'ਰਾਸਿ ੧੨',
      :en_title => 'Raas 12'
    },
    {
      :id => 15,
      :sequence => 15,
      :title => 'ਰੁਤਿ ੧',
      :en_title => 'Rut 1'
    },
    {
      :id => 16,
      :sequence => 16,
      :title => 'ਰੁਤਿ ੨',
      :en_title => 'Rut 2'
    },
    {
      :id => 17,
      :sequence => 17,
      :title => 'ਰੁਤਿ ੩',
      :en_title => 'Rut 3'
    },
    {
      :id => 18,
      :sequence => 18,
      :title => 'ਰੁਤਿ ੪',
      :en_title => 'Rut 4'
    },
    {
      :id => 19,
      :sequence => 19,
      :title => 'ਰੁਤਿ ੫',
      :en_title => 'Rut 5'
    },
    {
      :id => 20,
      :sequence => 20,
      :title => 'ਰੁਤਿ ੬',
      :en_title => 'Rut 6'
    },
    {
      :id => 21,
      :sequence => 21,
      :title => 'ਅਯਨ ੧',
      :en_title => 'Ayaan 1'
    },
    {
      :id => 22,
      :sequence => 22,
      :title => 'ਅਯਨ ੨',
      :en_title => 'Ayaan 2'
    }
  ]
)

Chapter.create!(
  [
    {
      :id => 1,
      :book => Book.find_by(:id => 1),
      :number => 1,
      :title => 'title1',
      :en_title => 'title in english1',
      :en_short_summary => 'short summary in english1',
      :en_long_summary => 'long summary in english1',
      :samapati => 'samapati1',
      :en_samapati => 'samapati in english1',
      :artwork_url => 'www.artworkURL1.com'
    },
    {
      :id => 2,
      :book => Book.find_by(:id => 2),
      :number => 1,
      :title => 'title2',
      :en_title => 'title in english2',
      :en_short_summary => 'short summary in english2',
      :en_long_summary => 'long summary in english2',
      :samapati => 'samapati2',
      :en_samapati => 'samapati in english2',
      :artwork_url => 'www.artworkURL2.com'
    }
  ]
)

ChhandType.create!(
  [
    {
      :id => 1,
      :name => 'type1',
      :en_name => 'en_name'
    },
    {
      :id => 2,
      :name => 'type2'
    }
  ]
)

Chhand.create!(
  [
    {
      :id => 1,
      :sequence => 1,
      :chapter => Chapter.find_by(:id => 1),
      :chhand_type => ChhandType.find_by(:id => 2),
      :vaak => 'vaak1'
    },
    {
      :id => 2,
      :sequence => 2,
      :chapter => Chapter.find_by(:id => 1),
      :chhand_type => ChhandType.find_by(:id => 1),
      :vaak => 'vaak2'
    }
  ]
)

Pauri.create!(
  [
    {
      :id => 1,
      :number => 1,
      :chapter => Chapter.find_by(:id => 1),
      :chhand => Chhand.find_by(:id => 1)
    },
    {
      :id => 2,
      :number => 2,
      :chapter => Chapter.find_by(:id => 1),
      :chhand => Chhand.find_by(:id => 1)
    }
  ]
)

PauriTranslation.create!(
  [
    {
      :id => 1,
      :en_translation => 'translation1',
      :en_translator => 'translator1',
      :pauri => Pauri.find_by(:id => 1)
    },
    {
      :id => 2,
      :en_translation => 'translation2',
      :en_translator => 'translator2',
      :pauri => Pauri.find_by(:id => 2)
    }
  ]
)

Tuk.create!(
  [
    {
      :id => 1,
      :chapter => Chapter.find_by(:id => 1),
      :pauri => Pauri.find_by(:id => 1),
      :sequence => 1,
      :content => 'content1',
      :original_content => 'original content1'
    },
    {
      :id => 2,
      :chapter => Chapter.find_by(:id => 1),
      :pauri => Pauri.find_by(:id => 1),
      :sequence => 2,
      :content => 'content2',
      :original_content => 'original content2'
    }
  ]
)

TukTranslation.create!(
  [
    {
      :id => 1,
      :tuk => Tuk.find_by(:id => 1),
      :en_translation => 'translation1',
      :en_translator => 'translator1'
    },
    {
      :id => 2,
      :tuk => Tuk.find_by(:id => 2),
      :en_translation => 'translation2',
      :en_translator => 'translator2'
    }
  ]
)

ExternalPauri.create!(
  [
    {
      :id => 1,
      :pauri => Pauri.find_by(:id => 1),
      :content => 'content1',
      :original_content => 'original content1',
      :bhai_vir_singh_footnote => 'footnote1'
    },
    {
      :id => 2,
      :pauri => Pauri.find_by(:id => 2),
      :content => 'content2',
      :original_content => 'original content2',
      :bhai_vir_singh_footnote => 'footnote2'
    }
  ]
)

TukFootnote.create!(
  [
    {
      :id => 1,
      :tuk => Tuk.find_by(:id => 1),
      :bhai_vir_singh_footnote => 'footnote1',
      :contentful_entry_id => 'entryid1'
    },
    {
      :id => 2,
      :tuk => Tuk.find_by(:id => 2)
    }
  ]
)

PauriFootnote.create!(
  [
    {
      :id => 1,
      :pauri => Pauri.find_by(:id => 1),
      :bhai_vir_singh_footnote => 'PauriFootnote1',
      :contentful_entry_id => 'contentful entry id 1'
    }
  ]
)
