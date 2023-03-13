# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Chapter' do
  context 'with missing fields`' do
    let(:unrequired_chapter_fields) do
      {
        :en_title => '',
        :en_short_summary => '',
        :en_long_summary => '',
        :samapati => '',
        :en_samapati => '',
        :artwork_url => ''
      }
    end

    it 'cannot save when missing `book_id`, `title`, and `number`' do
      expect { Chapter.create!(unrequired_chapter_fields) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'cannot save when missing `book_id` and `title`' do
      expect do
        Chapter.create!(unrequired_chapter_fields.merge({ :number => 2 }))
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'cannot save when `book_id` does not belong to a real book' do
      expect do
        Chapter.create!({ :book_id => 1, :number => 2, :title => 'Mangal' })
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'with duplicate chapter numbers' do
    let(:book1) { create(:book, :sequence => 1) }
    let(:book2) { create(:book, :sequence => 2) }

    it 'saves for different books' do
      create(:chapter, :book => book1, :number => 1)

      expect { create(:chapter, :book => book2, :number => 1) }.to be_valid
    end

    it 'cannot save for same book' do
      create(:chapter, :book => book1, :number => 1)

      # Attempt to create a second chapter with the same number for the same book
      expect { create(:chapter, :book => book1, :number => 1) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
