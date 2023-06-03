# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe Book do
  before do
    # Instantiate a book and chapter object for testing
    @book = create(:book)
    @chapter = create(:chapter, :book => @book)
    @chhand_type = create(:chhand_type)
  end

  describe '#import_chapter' do

    ##
    # These unit tests focus on method logic using mocks for File and CSV operations. While effective for verifying internal logic,
    # they may lead to false positives due to lack of real file system interaction. Consider supplementing with integration tests
    # for comprehensive validation.
    ##
    context 'when looking up file (`lib/imports/{book.sequence}/{chapter.number}.csv`)' do
      it 'raises an error when the CSV does not exist' do
        expect { @book.import_chapter(@chapter.number) }.to raise_error(RuntimeError, "CSV file lib/imports/1/#{@chapter.number}.csv not found")
      end

      it 'does NOT raise an error when the CSV is found' do
        file_path = "lib/imports/#{@book.sequence}/#{@chapter.number}.csv"

        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
        CSV

        csv_rows = CSV.parse(csv_content, :headers => true)

        allow(File).to receive(:exist?).with(file_path).and_return(true)
        allow(CSV).to receive(:foreach).with(file_path, :headers => true).and_return(csv_rows)

        expect { @book.import_chapter(@chapter.number) }.not_to raise_error
      end
    end

    context 'when the chapter number specified in the CSV is NOT found' do
      it 'raises an error' do
        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        expect { @book.import_chapter(99) }.to raise_error(RuntimeError, /Chapter not found: 99/)
      end
    end

    context 'when the chapter number specified in the CSV is found' do
      it 'raises an error' do
        @chapter99 = create(:chapter, :book => @book, :number => 99)
        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(@book.chapters).to receive(:find_by).with(:number => 99).and_return(@chapter99)
        allow(@chapter99).to receive(:csv_rows).and_return(CSV.parse(csv_content, :headers => true))

        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)
        allow(prompt).to receive(:yes?).and_return(true)

        expect { @book.import_chapter(99) }.not_to raise_error(RuntimeError, /Chapter not found/)
        @chapter99.destroy
      end
    end

    context 'when user says YES to prompt to update the chapter name' do
      it 'updates the title to the one from the CSV' do
        @chapter99 = create(:chapter, :number => 99, :title => 'TitleInDB', :book => @book)
        @chhand = create(:chhand, :chhand_type => @chhand_type, :chapter => @chapter99)
        @pauri = create(:pauri, :chapter => @chapter99, :chhand => @chhand, :number => 1)
        @tuk = create(:tuk, :pauri => @pauri, :chapter => @chapter99, :original_content => 'ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ', :sequence => 1)
        @tuk = create(:tuk, :pauri => @pauri, :chapter => @chapter99, :original_content => 'ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ', :sequence => 2)

        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,UpdatedTitleInCSV,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,UpdatedTitleInCSV,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(@book.chapters).to receive(:find_by).with(:number => 99).and_return(@chapter99)
        allow(@chapter99).to receive(:csv_rows).and_return(CSV.parse(csv_content, :headers => true))

        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)
        allow(prompt).to receive(:yes?).and_return(true)

        @book.import_chapter(99)
        expect(prompt).to have_received(:yes?).with("Do you want to continue and update this title to 'UpdatedTitleInCSV'?")
        expect(@chapter99.reload.title).to eq('UpdatedTitleInCSV')
      end
    end

    context 'when user says NO to prompt to update the chapter name' do
      it 'aborts and does NOT udpate the chapter.title' do
        @chapter99 = create(:chapter, :number => 99, :title => 'TitleInDB', :book => @book)

        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,UpdatedTitleInCSV,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,UpdatedTitleInCSV,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(@book.chapters).to receive(:find_by).with(:number => 99).and_return(@chapter99)
        allow(@chapter99).to receive(:csv_rows).and_return(CSV.parse(csv_content, :headers => true))

        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)
        allow(prompt).to receive(:yes?).and_return(false)

        expect { @book.import_chapter(99) }.to raise_error(RuntimeError, 'Aborted by user')
      end
    end

    context 'when the pauri does not exist in the database' do
      it 'raises an error' do
        @chapter99 = create(:chapter, :number => 99, :book => @book)

        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(@book.chapters).to receive(:find_by).with(:number => 99).and_return(@chapter99)
        allow(@chapter99).to receive(:csv_rows).and_return(CSV.parse(csv_content, :headers => true))

        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)
        allow(prompt).to receive(:yes?).and_return(true)

        expect { @book.import_chapter(99) }.to raise_error(StandardError, /Pauri not found/)
      end
    end

    context 'when the tuk does not exist in the database' do
      it 'raises an error when the tuk content is too different' do
        @chapter99 = create(:chapter, :number => 99, :book => @book)
        @chhand = create(:chhand, :chhand_type => @chhand_type, :chapter => @chapter99)
        @pauri = create(:pauri, :chapter => @chapter99, :chhand => @chhand, :number => 1)
        @tuk = create(:tuk, :pauri => @pauri, :chapter => @chapter99, :original_content => 'ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ', :sequence => 1)
        @tuk = create(:tuk, :pauri => @pauri, :chapter => @chapter99, :original_content => 'ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ', :sequence => 2)

        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, something else",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, changed up a bit",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(@book.chapters).to receive(:find_by).with(:number => 99).and_return(@chapter99)
        allow(@chapter99).to receive(:csv_rows).and_return(CSV.parse(csv_content, :headers => true))

        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)
        allow(prompt).to receive(:yes?).and_return(true)

        expect { @book.import_chapter(99) }.to raise_error(StandardError, /Tuk not found/)
      end
    end
  end
end
