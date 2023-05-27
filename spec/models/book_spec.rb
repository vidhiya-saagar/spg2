require 'rails_helper'
require 'csv'

RSpec.describe Book, :type => :model do
  before do
    # Instantiate a book and chapter object for testing
    @book = create(:book)
    @chapter = create(:chapter, :book => @book)
    @chhand_type = create(:chhand_type)
  end

  describe '#import_chapter' do
    context 'when looking up file (`lib/imports/{book.sequence}/{chapter.number}.csv`)' do
      it 'raises an error when the CSV does not exist' do
        expect { @book.import_chapter(99) }.to raise_error(RuntimeError, %r{CSV file lib/imports/1/99.csv not found})
      end

      it 'does NOT raise an error when the CSV is found' do
        file_name = "lib/imports/#{@book.sequence}/#{@chapter.number}.csv"
        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
        CSV

        allow(File).to receive(:exist?).with(file_name).and_return(true)
        allow(CSV).to receive(:parse).with(file_name, :headers => true).and_return(CSV.parse(csv_content, :headers => true))

        expect { @book.import_chapter(@chapter.number) }.not_to raise_error
      end
    end

    context 'when the chapter number specified in the CSV is NOT found' do
      it 'raises an error' do
        file_name = "lib/imports/#{@book.sequence}/99.csv"
        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(File).to receive(:exist?).with(file_name).and_return(true)
        allow(CSV).to receive(:parse).with(file_name, :headers => true).and_return(CSV.parse(csv_content, :headers => true))
        expect { @book.import_chapter(99) }.to raise_error(RuntimeError, /Chapter not found: 99/)
      end
    end

    context 'when the chapter number specified in the CSV is found' do
      it 'raises an error' do
        @chapter99 = create(:chapter, :book => @book, :number => 99)
        file_name = "lib/imports/#{@book.sequence}/#{@chapter99.number}.csv"
        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(File).to receive(:exist?).with(file_name).and_return(true)
        allow(CSV).to receive(:parse).with(file_name, :headers => true).and_return(CSV.parse(csv_content, :headers => true))

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
        @chapter99 = create(:chapter, :number => 99, :title => 'ਇਸ਼੍ਟ ਦੇਵ-ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ-ਮੰਗਲ', :book => @book)
        @chhand = create(:chhand, :chhand_type => @chhand_type, :chapter => @chapter99)
        @pauri = create(:pauri, :chapter => @chapter99, :chhand => @chhand, :number => 1)
        @tuk = create(:tuk, :pauri => @pauri, :chapter => @chapter99, :original_content => 'ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ', :sequence => 1)
        @tuk = create(:tuk, :pauri => @pauri, :chapter => @chapter99, :original_content => 'ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ', :sequence => 2)

        file_name = "lib/imports/#{@book.sequence}/#{@chapter99.number}.csv"
        csv_content = <<~CSV
          Chapter_Number,Chapter_Name,Chhand_Type ,Tuk,Pauri_Number,Tuk_Number,Pauri_Translation_EN,Translation_EN ,Footnotes,Custom_Footnotes,Extended_Ref ,Assigned_Singh,Status,Extended_Meaning
          99,ਇਸ਼੍ਟ ਦੇਵ: ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ । ਮੰਗਲ,ਦੋਹਰਾ,"ਤੀਨੋ ਕਾਲ ਅਲਿਪਤ ਰਹਿ, ਖੋਜੈਂ ਜਾਂਹਿ ਪ੍ਰਬੀਨ",1,1,,,"ਅਲਿਪਤ = ਅਸੰਗ। ਜੋ ਲਿਪਾਯਮਾਨ ਨਾ ਹੋਵੇ, ਨਿਰਲੇਪ। ਪ੍ਰਬੀਨ = ਚਤੁਰ ਪੁਰਸ਼, ਲਾਇਕ।",,,,,
          99,ਇਸ਼੍ਟ ਦੇਵ: ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ । ਮੰਗਲ,ਦੋਹਰਾ,"ਬੀਨਤਿ ਸਚਿਦਾਨੰਦ ਤ੍ਰੈ, ਜਾਨਹਿਂ ਮਰਮ ਰਤੀ ਨ",1,2,,,"ਬੀਨਤਿ = ਵਿੱਤ੍ਰੇਕ ਕਰਦੇ ਹਨ। ਇਹ ਨਹੀਂ, ਇਹ ਹੈ, ਇਉਂ ਵਿਚਾਰ ਦੁਆਰਾ ਉਸਦੇ ਸਰੂਪ ਲੱਛਣਾਂ ਨੂੰ ਛਾਂਟ ਲੈਂਦੇ ਹਨ, ਭਾਵ ਜਾਣ ਲੈਂਦੇ ਹਨ। ਮਰਮ = ਭੇਤ।",,,,,
        CSV

        allow(File).to receive(:exist?).with(file_name).and_return(true)
        allow(CSV).to receive(:parse).with(file_name, :headers => true).and_return(CSV.parse(csv_content, :headers => true))

        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:say)
        allow(prompt).to receive(:yes?).and_return(true)


        @book.import_chapter(99)
        expect(prompt).to have_received(:yes?).with("Do you want to continue and update this title to 'ਇਸ਼੍ਟ ਦੇਵ: ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ । ਮੰਗਲ'?")
        expect(@chapter99.reload.title).to eq('ਇਸ਼੍ਟ ਦੇਵ: ਸ਼੍ਰੀ ਅਕਾਲ ਪੁਰਖ । ਮੰਗਲ')
      end
    end

    # context 'when the last row chapter number does not match' do
    #   it 'aborts all changes' do
    #     # Stub your CSV read method to return data with last row chapter_number 95
    #     expect { @book.import_chapter(3) }.to raise_error(StandardError, /Aborted due to chapter number mismatch/)
    #   end
    # end

    # context 'when chapter title in CSV does not match with database and user confirms update' do
    #   it 'updates the chapter title' do
    #     # Mock the user input to return true
    #     allow(STDIN).to receive(:gets).and_return("yes\n")
    #     @book.import_chapter(1)
    #     expect(@chapter.reload.title).to eq('chapter_name') # Replace "chapter_name" with actual value
    #   end
    # end

    # context 'when chapter title in CSV does not match with database and user denies update' do
    #   it 'aborts the operation' do
    #     # Mock the user input to return false
    #     allow(STDIN).to receive(:gets).and_return("no\n")
    #     expect { @book.import_chapter(1) }.to raise_error(StandardError, /Aborted by user/)
    #   end
    # end

    # context 'when the pauri does not exist in the database' do
    #   it 'raises an error' do
    #     # Stub your CSV read method to return data with pauri 23
    #     expect { @book.import_chapter(1) }.to raise_error(StandardError, /Pauri does not exist in database/)
    #   end
    # end
  end
end
