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
      expect { Chapter.create!(unrequired_chapter_fields) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'cannot save when missing `book_id` and `title`' do
      expect do
        Chapter.create!(unrequired_chapter_fields.merge({ :number => 2 }))
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'cannot save when `book_id` does not belong to a real book' do
      expect do
        Chapter.create!({ :book_id => 1, :number => 2, :title => 'Mangal' })
      end.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end
end
