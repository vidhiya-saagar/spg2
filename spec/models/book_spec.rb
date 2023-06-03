# rubocop:disable RSpec/NestedGroups, RSpec/MultipleExpectations
# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe Book do
  let(:book) { create(:book) }

  describe '#import_chapter' do
    context 'when the `chapter.number` is invalid' do
      it 'raises an error if the `chapter_number` does not exist in `book`' do
        expect { book.import_chapter(99) }.to raise_error(RuntimeError, /Chapter not found: 99/)
      end

      it 'raises an error if the CSV does not exist' do
        # Create the `Chapter` row only! Not the CSV.
        create(:chapter, :book => book, :number => 100)
        expect { book.import_chapter(100) }.to raise_error(RuntimeError, 'CSV file lib/imports/1/100.csv not found')
      end
    end

    context 'when the `chapter_number` is valid' do
      csv_content = <<~CSV
        Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
      CSV

      csv_rows = CSV.parse(csv_content, :headers => true)

      it 'does not raise an error' do
        let(:chapter) { create(:chapter, :book => book) }
        file_path = "lib/imports/#{book.sequence}/#{chapter.number}.csv"

        allow(File).to receive(:exist?).with(file_path).and_return(true)
        allow(CSV).to receive(:foreach).with(file_path, :headers => true).and_return(csv_rows)

        expect { book.import_chapter(chapter.number) }.not_to raise_error
      end
    end

    context 'when given valid input and CSV' do
      let(:chapter_number) { 99 }
      let(:chapter_title) { 'ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ' }
      let(:csv_content) do
        <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,,,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,,,,,,
        CSV
      end

      before do
        # Initialize mocks for TTY::Prompt
        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)

        # Associations for the chapter - This one reflects out mock `csv_content`
        let(:chapter) { create(:chapter, :number => chapter_number, :book => book, :title => chapter_title) }
        let(:chhand) { create(:chhand, :chhand_type => '', :chapter => chapter) }
        let(:pauri) { create(:pauri, :chapter => chapter, :chhand => chhand, :number => 1) }
        create(:tuk, :pauri => pauri, :chapter => chapter, :original_content => 'ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ', :sequence => 1)
        create(:tuk, :pauri => pauri, :chapter => chapter, :original_content => 'ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ', :sequence => 2)

        # Mocking the CSV data
        allow(book.chapters).to receive(:find_by).with(:number => chapter_number).and_return(chapter)
        allow(chapter).to receive(:csv_rows).and_return(CSV.parse(csv_content, :headers => true))
      end

      context 'when prompted to update `chapter.title`' do
        it 'does not prompt user if the `chapter.title` is unchanged' do
          allow(prompt).to receive(:yes?)
          book.import_chapter(chapter_number)
          expect(prompt).not_to have_received(:yes?)

          expect(chapter.reload.title).to eq(chapter_title)
        end

        it 'updates the `chapter.title` if user confirms' do
          # Change the `chapter.title` so it is different than the one in CSV
          chapter.update(:title => 'Different title')

          allow(prompt).to receive(:yes?).and_return(true)
          book.import_chapter(chapter_number)

          expect(prompt).to have_received(:yes?).with("Do you want to continue and update this title to '#{chapter_title}'?")
          expect(chapter.reload.title).to eq(chapter_title)
        end

        it 'aborts and does not update the chapter title if user declines' do
          # Change the `chapter.title` so it is different than the one in CSV
          chapter.update(:title => 'Something Else - Suraj Suraj Suraj')
          allow(prompt).to receive(:yes?).and_return(false)
          expect { book.import_chapter(chapter_number) }.to raise_error(RuntimeError, 'Aborted by user')
        end
      end

      context 'when `chapter` associations do not exist' do
        it 'raises an error when `pauri` is nil' do
          pauri.destroy
          expect { book.import_chapter(chapter_number) }.to raise_error(StandardError, /Pauri not found/)
        end

        it 'raises an error when `tuks` are nil' do
          Tuk.destroy_all
          expect { book.import_chapter(chapter_number) }.to raise_error(StandardError, /Tuk not found/)
        end

        it 'raises an error when `tuk` content does not match' do
          tuk = chapter.tuks.first
          tuk.update(:content => 'Changed', :original_content => 'Totally Different')
          Tuk.destroy_all
          expect { book.import_chapter(chapter_number) }.to raise_error(StandardError, /Tuk not found/)
        end
      end

      # TODO: Write tests for Translations, Footnotes, etc.
    end
  end
end

# rubocop:enable RSpec/NestedGroups, RSpec/MultipleExpectations
