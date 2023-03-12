require 'rails_helper'

RSpec.describe 'Chapter' do
  context 'Missing fields`' do
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
      end.to raise_error(/Book must exist/)
    end
  end

  context 'Preventing duplicate chapter numbers' do
    it 'allow creation of duplicate chapter 1s, if they are for different books' do
    end
  end
end
