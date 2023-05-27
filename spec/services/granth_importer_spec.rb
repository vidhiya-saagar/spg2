# frozen_string_literal: true

# rubocop:disable RSpec/MultipleExpectations

require 'rails_helper'

RSpec.describe GranthImporter, :type => :model do
  fixtures :books

  describe '#execute' do
    before do
      GranthImporter.new(csv_data).execute
    end

    let(:csv_data) do
      <<~ROWS
        Book_Name,Chapter_Number,Chapter_Name,Chhand_Type,Tuk,Pauri_Number,Footnotes,Extended_Ref,Extended_Meaning,Translation_EN
        Sri Nanak Parkash 1,1,"ਮੰਗਲਾ ਚਰਨ, ਨਾਮ ਮਹਿਮਾ ਬਰਨਨੰ, ਨਾਮ ਪ੍ਰਥਮੋ ਧ੍ਯਾਇ",ਦੋਹਰਾ,ਏਕੁੰਕਾਰਾ¹ ਸਤਿਗੁਰੂ ਤਿਹਿ ਪ੍ਰਸਾਦਿ ਸਚੁ ਹੋਇ,1,"¹ਇਹ ਪਾਠ ਛਪੇ ਹੋਏ ਨੁਸਖੇ ਦਾ ਹੈ, ਕਈ ਇਕ ਲਿਖਤੀ ਨੁਸਖਿਆਂ ਤੋਂ ਬੀ ਇਹ ਪਾਠ ਮਿਲਿਆ ਹੈ। ਕਵੀ ਜੀ ਦੇ ਨਿਜ ਲੇਖਣੀ ਲਿੱਖਤ ਇਸ ਪਦ ਦੇ ਜੋੜ ‘ਏਕੋਂਕਾਰ’ ਅਸੀਂ ਜਿਲਦ ੧ ‘ਪ੍ਰਸਤਾਵਨਾਂ’ ਦੇ ਪੰਨਾ ੨੨੩ ਪਰ ੧੨ਵੇਂ ਅੰਕ ਵਿਚ ਦਰਸਾ ਆਏ ਹਾਂ",,,
        Sri Nanak Parkash 1,1,"ਮੰਗਲਾ ਚਰਨ, ਨਾਮ ਮਹਿਮਾ ਬਰਨਨੰ, ਨਾਮ ਪ੍ਰਥਮੋ ਧ੍ਯਾਇ",ਦੋਹਰਾ,ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫਤੇ¹ ਵਿਘਨ ਵਿਨਾਸ਼ਨ ਸੋਇ,1,"¹ਛਪੇ ਹੋਏ ਅਕਸਰ ਨੁਸਖਿਆਂ ਵਿਚ ਅਤੇ ਦੋ ਕਲਮੀ ਨੁਸਖਿਆਂ ਵਿਚ ਜਿਨ੍ਹਾਂ ਵਿਚੋਂ ਇਕ ਸ੍ਰੀਮਾਨ ਸੱਚਖੰਡ ਵਾਸੀ ਡਾਕਟਰ ਚਰਨ ਸਿੰਘ ਜੀ (ਸੂਰਜ ਪ੍ਰਕਾਸ਼ ਦੇ ਮੰਨੇ ਹੋਏ ਪੰਡਤ ਜੀ) ਦੇ ਸੰਚਯ ਵਿਚੋਂ ਹੈ, ਪਾਠ ‘ਫਤੇ’ ਹੀ ਹੈ। ਇਕ ਛਾਪੇ ਦੇ ਗ੍ਰੰਥ ਵਿਚ ਪਾਠ ‘ਫਤਹ’ ਦੇਖਣ ਵਿਚ ਆਏ।",,,
      ROWS
    end

    it 'creates a `chapter` under the correct `book`' do
      book = Book.find_by(:en_title => 'Sri Nanak Parkash 1')
      chapter = Chapter.find_by(:book => book, :number => 1)
      expect(chapter).not_to be_nil
    end

    it 'creates a `chapter` with correct id and title' do
      chapter = Chapter.find_by(:number => 1, :title => 'ਮੰਗਲਾ ਚਰਨ, ਨਾਮ ਮਹਿਮਾ ਬਰਨਨੰ, ਨਾਮ ਪ੍ਰਥਮੋ ਧ੍ਯਾਇ')
      expect(chapter).not_to be_nil
    end

    it 'creates a `chhand_type` with correct `name`' do
      chhand_type = ChhandType.find_by(:name => 'ਦੋਹਰਾ')
      expect(chhand_type).not_to be_nil
    end

    it 'creates a `chhand` with correct `sequence` in the `chapter`' do
      chhand = Chhand.find_by(:sequence => 1, :chapter_id => 1)
      expect(chhand).not_to be_nil
    end

    it 'creates a `pauri` with correct `number` in the chhand' do
      pauri = Pauri.find_by(:number => 1, :chhand_id => 1)
      expect(pauri).not_to be_nil
    end

    describe 'tuks' do
      let(:pauri) { Pauri.find_by(:number => 1, :chhand_id => 1) }
      let(:tuk1) { Tuk.find_by(:sequence => 1, :pauri => pauri) }
      let(:tuk2) { Tuk.find_by(:sequence => 2, :pauri => pauri) }

      it 'creates the first `tuk` with correct `sequence` and `content`' do
        expect(tuk1).not_to be_nil
        expect(tuk1.content).to eq('ਏਕੁੰਕਾਰਾ ਸਤਿਗੁਰੂ ਤਿਹਿ ਪ੍ਰਸਾਦਿ ਸਚੁ ਹੋਇ')
        expect(tuk1.pauri.chhand.chapter.number).to eq(1)
      end

      it 'creates the second `tuk` with correct `sequence` and content' do
        expect(tuk2).not_to be_nil
        expect(tuk2.content).to eq('ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫਤੇ ਵਿਘਨ ਵਿਨਾਸ਼ਨ ਸੋਇ')
        expect(tuk2.pauri.chhand.chapter.number).to eq(1)
      end

      it 'creates `tuk_footnotes`' do
        expect(TukFootnote.count).to eq(2)
        expect(tuk1.footnote.bhai_vir_singh_footnote).to include('¹ਇਹ ਪਾਠ ਛਪੇ ਹੋਏ ਨੁਸਖੇ ਦਾ ਹੈ,')
        expect(tuk2.footnote.bhai_vir_singh_footnote).to include('¹ਛਪੇ ਹੋਏ ਅਕਸਰ ਨੁਸਖਿਆਂ ਵਿਚ ਅਤੇ ਦੋ ਕਲਮੀ')
      end
    end
  end

  describe 'importing an invalid book name' do
    let(:csv_data) do
      <<~ROWS
        Book_Name,Chapter_Number,Chapter_Name,Chhand_Type,Tuk,Pauri_Number,Footnotes,Extended_Ref,Extended_Meaning,Translation_EN
        Invalid Book Name,1,"Example Chapter Name",Example Chhand Type,Example Tuk,1,,,,
      ROWS
    end

    it 'raises an error when the book name is not in the allowed list' do
      expect do
        GranthImporter.new(csv_data).execute
      end.to raise_error(GranthImporter::InvalidBookNameError)
    end
  end

  describe 'importing data with Gurbani References' do
    context 'without `bhai_vir_singh_footnotes`' do
      let(:csv_data) do
        <<~ROWS
          Book_Name,Chapter_Number,Chapter_Name,Chhand_Type,Tuk,Pauri_Number,Footnotes,Extended_Ref,Extended_Meaning,Translation_EN
          Sri Nanak Parkash 2,10,"ਸ਼ਾਰਦਾ ਮੰਗਲ। ਜਗਨ ਨਾਥ, ਕਲਜੁਗ ਪ੍ਰਸੰਗ",[ਸ਼੍ਰੀ ਬਾਲਾ ਸੰਧੁਰੁ ਵਾਚ] ਚੌਪਈ,ਪੰਡੇ ਕਹੈਂ 'ਆਰਤੀ ਕੈਸੀ?,9,,,,
          Sri Nanak Parkash 2,10,"ਸ਼ਾਰਦਾ ਮੰਗਲ। ਜਗਨ ਨਾਥ, ਕਲਜੁਗ ਪ੍ਰਸੰਗ",[ਸ਼੍ਰੀ ਬਾਲਾ ਸੰਧੁਰੁ ਵਾਚ] ਚੌਪਈ,ਨਿਤਪ੍ਰਤਿ ਕਰਤਿ ਰਹੋ ਕਹੁ ਤੈਸੀ',9,,,,
          Sri Nanak Parkash 2,10,"ਸ਼ਾਰਦਾ ਮੰਗਲ। ਜਗਨ ਨਾਥ, ਕਲਜੁਗ ਪ੍ਰਸੰਗ",[ਸ਼੍ਰੀ ਬਾਲਾ ਸੰਧੁਰੁ ਵਾਚ] ਚੌਪਈ,ਤਿਨ ਤੇ ਸੁਨਿ ਕੇ ਕ੍ਰਿਪਾ ਨਿਧਾਨਾ,9,,,,
          Sri Nanak Parkash 2,10,"ਸ਼ਾਰਦਾ ਮੰਗਲ। ਜਗਨ ਨਾਥ, ਕਲਜੁਗ ਪ੍ਰਸੰਗ",[ਸ਼੍ਰੀ ਬਾਲਾ ਸੰਧੁਰੁ ਵਾਚ] ਚੌਪਈ,ਸ਼ਬਦ ਆਰਤੀ ਰੀਤਿ ਬਖਾਨਾ,9,,,,
          Sri Nanak Parkash 2,10,"ਸ਼ਾਰਦਾ ਮੰਗਲ। ਜਗਨ ਨਾਥ, ਕਲਜੁਗ ਪ੍ਰਸੰਗ",ਦੋਹਰਾ,"ਇਸ ਪ੍ਰਕਾਰ ਕੀ ਆਰਤੀ, ਨਿਤ ਉਤਾਰਿ ਕਰਤਾਰ",10,,ਸ੍ਰੀ ਮੁਖਵਾਕ ॥ ਧਨਾਸਰੀ ਮਹਲਾ ੧ ਆਰਤੀ ੴ ਸਤਿਗੁਰ ਪ੍ਰਸਾਦਿ ॥ ਗਗਨ ਮੈ ਥਾਲੁ ਰਵਿ ਚੰਦੁ ਦੀਪਕ ਬਨੇ ਤਾਰਿਕਾ ਮੰਡਲ ਜਨਕ ਮੋਤੀ ॥ ਧੂਪੁ ਮਲਆਨਲੋ ਪਵਣੁ ਚਵਰੋ ਕਰੇ ਸਗਲ ਬਨਰਾਇ ਫੂਲੰਤ ਜੋਤੀ ॥੧॥ ਕੈਸੀ ਆਰਤੀ ਹੋਇ ਭਵ ਖੰਡਨਾ ਤੇਰੀ ਆਰਤੀ ॥ ਅਨਹਤਾ ਸਬਦ ਵਾਜੰਤ ਭੇਰੀ ॥੧॥ ਰਹਾਉ ॥ ਸਹਸ ਤਵ ਨੈਨ ਨਨ ਨੈਨ ਹੈ ਤੋਹਿ ਕਉ ਸਹਸ ਮੂਰਤਿ ਨਨਾ ਏਕ ਤੋਹੀ ॥ ਸਹਸ ਪਦ ਬਿਮਲ ਨਨ ਏਕ ਪਦ ਗੰਧ ਬਿਨੁ ਸਹਸ ਤਵ ਗੰਧ ਇਵ ਚਲਤ ਮੋਹੀ ॥੨॥ ਸਭ ਮਹਿ ਜੋਤਿ ਜੋਤਿ ਹੈ ਸੋਇ ॥ਤਿਸ ਕੈ ਚਾਨਣਿ ਸਭ ਮਹਿ ਚਾਨਣੁ ਹੋਇ ॥ ਗੁਰ ਸਾਖੀ ਜੋਤਿ ਪਰਗਟੁ ਹੋਇ ॥ਜੋ ਤਿਸੁ ਭਾਵੈ ਸੁ ਆਰਤੀ ਹੋਇ ॥੩॥ ਹਰਿ ਚਰਣ ਕਮਲ ਮਕਰੰਦ ਲੋਭਿਤ ਮਨੋ ਅਨਦਿਨੋ ਮੋਹਿ ਆਹੀ ਪਿਆਸਾ ॥ ਕ੍ਰਿਪਾ ਜਲੁ ਦੇਹਿ ਨਾਨਕ ਸਾਰਿੰਗ ਕਉ ਹੋਇ ਜਾ ਤੇ ਤੇਰੈ ਨਾਮਿ ਵਾਸਾ ॥੪॥੧॥੭॥੯॥,,
          Sri Nanak Parkash 2,10,"ਸ਼ਾਰਦਾ ਮੰਗਲ। ਜਗਨ ਨਾਥ, ਕਲਜੁਗ ਪ੍ਰਸੰਗ",ਦੋਹਰਾ,"ਮਨ ਕੋ ਰੋਕਿ ਜੁ ਕਰਤਿ ਇਉਂ, ਫਿਰ ਨ ਪਾਇ ਸੰਸਾਰ'",10,,,,
        ROWS
      end

      it 'creates an `external_pauri` with `content`' do
        GranthImporter.new(csv_data).execute
        book = Book.find_by(:en_title => 'Sri Nanak Parkash 2')
        chapter = Chapter.find_by(:book => book, :number => 10)
        pauri = chapter.pauris.find_by(:number => 10)
        external_pauri = ExternalPauri.find_by(:pauri => pauri)

        expect(external_pauri.original_content).to include('ਸ੍ਰੀ ਮੁਖਵਾਕ ॥ ਧਨਾਸਰੀ ਮਹਲਾ ੧ ਆਰਤੀ ੴ')
        expect(external_pauri.content).to include('ਸ੍ਰੀ ਮੁਖਵਾਕ ॥ ਧਨਾਸਰੀ ਮਹਲਾ ੧ ਆਰਤੀ ੴ')
        expect(external_pauri.bhai_vir_singh_footnote).to be_nil
      end
    end

    context 'with `bhai_vir_singh_footnote`' do
      let(:csv_data) do
        <<~ROWS
          Book_Name,Chapter_Number,Chapter_Name,Chhand_Type,Tuk,Pauri_Number,Footnotes,Extended_Ref,Extended_Meaning,Translation_EN
          Rut 3,27,ਭਾਈ ਨੰਦਲਾਲ ਜੀ। ਹੋਲੀ,ਚੌਪਈ,ਸੁਨਤਿ ਪ੍ਰਸੰਨ ਗੁਰੂ ਅਭਿਰਾਮ,16,,ਜਥਾ ਯਾਂ ਹੋਲੀ ਗੁਲੇ ਹੋਲੀ ਬਬਾਗ਼ੇ ਦਹਰ ਈਂ ਬਿਸ਼ਗੁਫਤਾ। ਲਬੇ ਚੂੰ ਗੁੰਚਹ ਰਾ ਫਰਖੁੰਦਹ ਖ਼ੂ ਕਰਦ¹। ਗੁਲਾਬੋ ਅੰਬਰੋ ਮੁਸ਼ਕੋ ਅਬੀਰੋ। ਚੂੰ ਬਾਰਾਂ ਬਾਰਸ਼ੇ ਅਜ਼ ਸੂਬਸੂ ਕਰਦ²। ਗੁਲਾਲ ਅਫਸ਼ਾਨੀਏ ਦਸਤੇ ਮੁਬਾਰਿਕ। ਜ਼ਮੀਨੋਂ ਆਸਮਾਂ ਰਾ ਸੁਰਖ਼ਰੂ ਕਰਦ³। ਜ਼ਹੇ ਪਿਚਕਾਰੀਏ ਪੁਰ ਜ਼ਅਫਰਾਨੀ। ਕਿ ਹਰ ਬੇਰੰਗ ਦਾ ਖੁਸ਼ਰੰਗ ਰੂ ਕਰਦ⁴। ਦੁਆਲਮ ਗਸ਼ਤ ਰੰਗੀਂ ਅਜ਼ ਤੁਫੈਲਸ਼। ਚੁ ਸ਼ਾਹਿਮ ਜਾਮਹ ਰੰਗੀਂ ਦਰ ਗਲੂ ਕਰਦ⁵। ਕਸੇ ਕੋ ਦੀਦਾਹ ਦੀਦਾਰੇ ਮੁਕੱਦਸ। ਮੁਰਾਦੇ ਉਮਰ ਰਾ ਹਾਸਲ ਨਿਕੋ ਕਰਦ⁶। ਸ਼ਵਦ ਕੁਰਬਾਨ ਖ਼ਾਕੇ ਸਾਧ ਸੰਗਤ!। ਦਿਲੇ ‘ਗੋਇਆ’ ਹਮੀਂ ਰਾ ਆਰਜ਼ੂ ਕਰਦ†⁷।,"¹ਹੋਲੀ ਦਾ ਫੁਲ ਇਸ ਦੁਨੀਆਂ ਦੇ ਬਾਗ਼ ਵਿਚ ਖਿੜ ਪਿਆ, ਬੁੱਲ੍ਹਾਂ ਨੂੰ ਕਲੀ ਵਾਂਙ ਮੁਬਾਰਕ ਸੁਭਾਵ ਵਾਲਾ ਕਰ ਦਿਤਾ ਹੈ ਭਾਵ ਹਰੇਕ ਦੇ ਬੁੱਲ ਮੁਸਕਰਾ ਰਹੇ ਹਨ। ²ਗੁਲਾਬ, ਅੰਬਰ, ਕਸਤੂਰੀ, ਤੇ ਅੰਬੀਰ ਮੀਂਹ ਵਾਂਙੂ ਚਾਰ ਪਾਸਿਓਂ ਵਰਖਾ ਕਰ ਰਹੇ ਹਨ। ³ਸ੍ਰੀ ਗੁਰੂ ਗੋਬਿੰਦ ਸਿੰਘ ਜੀ ਦੇ) ਮੁਬਾਰਿਕ ਹੱਥਾਂ ਦਾ ਗੁਲਾਲ ਉਡਾਉਣਾ ਜ਼ਮੀਨ ਤੇ ਅਸਮਾਨ ਨੂੰ ਲਾਲ ਰੰਗਾ ਕਰ ਰਿਹਾ ਹੈ, ਜ਼ਿਮੀਂ ਮੈਲੀ ਤੇ ਅਸਮਾਨ ਕਾਲਾ ਹੈ, ਗੁਰੂ ਜੀ ਦੀ ਗੁਲਾਲ ਅਫਸ਼ਾਨੀ ਨੇ ਦੁਹਾਂ ਨੂੰ ਲਾਲ ਰੰਗੇ ਕਰ ਦਿਤਾ ਹੈ। ਸੁਰਖਰੂ ਹੋਣਾ ਕਿਸੇ ਜ਼ਿੰਮੇਂਵਾਰੀ ਤੋਂ ਯਾ ਕਿਸੇ ਪਾਪ ਤੋਂ ਛੁਟਕਾਰਾ ਪਾਉਣ ਦਾ ਬੀ ਮੁਹਾਵਰਾ ਹੈ। ⁴ਵਾਹਵਾ ਹੈ ਓਸ ਕੇਸਰ ਰੰਗ ਨਾਲ (ਭਰੀ) ਪਿਚਕਾਰੀ ਨੂੰ (ਜੋ ਕਲਗੀਧਰ ਜੀ ਦੇ ਹਥ ਵਿਚ ਹੈ) ਕਿ ਜਿਸ ਨੇ ਹਰ ਬੇ ਰੰਗ ਨੂੰ ਖੁਸ਼ ਰੰਗ ਚਿਹਰੇ ਵਾਲਾ ਬਣਾ ਦਿਤਾ ਹੈ (ਬੇ ਰੰਗ ਬੀਮਾਰ ਯਾ ਉਦਾਸ ਹੁੰਦਾ ਹੈ)। ⁵ਉਸ ਗੁਰੂ ਦੀ) ਤੁਫੈਲ ਅਜ ਦੋਂਹ ਜਹਾਨਾਂ ਨੂੰ ਰੰਗ ਲਗ ਗਿਆ ਹੈ, (ਜਦੋਂ ਕਿ ਮੇਰੇ) ਸ਼ਾਹ ਨੇ ਰੰਗ ਭਰਿਆ ਕਪੜਾ ਗਲੇ ਵਿਚ ਪਹਿਨਿਆ ਹੋਇਆ ਹੈ। ⁶ਜਿਸ ਕਿਸੇ ਨੇ ਇਹ ਪਵਿੱਤ੍ਰ ਦੀਦਾਰ (ਗੁਰੂ ਜੀ ਦਾ) ਡਿੱਠਾ ਹੈ ਉਸ ਨੇ ਆਪਣੀ ਉਮਰ ਦੀ ਮੁਰਾਦ ਚੰਗੀ ਤਰ੍ਹਾਂ ਪਾ ਲਈ ਹੈ। ⁷ਮੈਂ ਸਾਧ ਸੰਗਤ ਦੀ ਖਾਕ ਤੋਂ ਸਦਕੇ ਹੋ ਰਿਹਾ ਹਾਂ, ਗੋਯਾ (ਭਾਵ ਨੰਦ ਲਾਲ) ਦਾ ਦਿਲ ਇਸੇ (ਵਕਤ) ਨੂੰ ਤਰਸ ਰਿਹਾ ਸੀ। †ਭਾਈ ਨੰਦ ਲਾਲ ਜੀ ਦੀ ਇਹ ਉਗਾਹੀ ਇਤਿਹਾਸਕ ਸਬੂਤ ਹੈ ਹੋਲੇ ਦੇ ਹੋਣ ਦਾ। ਅਲਤਾ, ਅਤਰ, ਅੰਬੀਰ, ਗੁਲਾਬ, ਗੁਲਾਲ, ਦੀਵਾਨ, ਕੀਰਤਨ, ਮਹੱਲਾ ਚੜ੍ਹਨਾ, ਇਹ ਕੌਤਕ ਗੁਰੂ ਕੇ ਦਰਬਾਰ ਵਿਚ ਹੁੰਦੇ ਰਹੇ ਹਨ। ਨਵੀਨ ਅਕਾਲੀਆਂ ਨੇ ਸ੍ਰੀ ਹਰਿਮੰਦਰ ਵਿਚੋਂ ਕੁਰੀਤੀਆਂ ਕਢਦਿਆਂ ਹੋਇਆਂ ਕਈ ਪੁਰਾਤਨ ਰੀਤੀਆਂ ਤੇ ਕਈ ਸ਼ੁਭ ਰੀਤੀਆਂ ਬਿਨਾਂ ਪੰਥਕ ਆਗ੍ਯਾ ਦੇ ਦੂਰ ਕੀਤੀਆਂ ਹਨ, ਗ਼ਾਲਬਨ ਗੁਰ ਇਤਿਹਾਸ ਤੋਂ ਨਾਵਾਕਫੀ ਵਿਚ ਯਾ ਪੱਛਮੀ ਰੌਸ਼ਨੀ ਦੇ ਚੁੰਧਿਆਏ ਘਬਰਾ ਵਿਚ। ਜੇ ਕੁਛ ਹੋਲੇ ਲਈ ਕੀਤਾ ਗਿਆ ਹੈ ਉਹ ਭਾਈ ਨੰਦ ਲਾਲ ਜੀ ਦੇ ਅੱਖੀਂ ਡਿੱਠੇ ਗੁਰੂ ਦਰਬਾਰ ਦੇ ਵਰਤਾਰ ਦੇ ਉਲਟ ਹੈ। ਦੂਰ ਕਰਨ ਵਾਲੀ ਗਲ ਗੰਦ ਮੰਦ ਤੇ ਵਹਿਸ਼ੀਪੁਣਾ ਸੀ, ਪਰੰਤੂ ਆਨੰਦ ਹੁਲਾਸ ਤੇ ਬਸੰਤ ਰੁਤ ਦੇ ਖੇੜੇ ਦੇ ਸਾਮਾਨ ਤੇ ਚੜ੍ਹਦੀਆਂ ਕਲਾਂ ਦੇ ਪ੍ਰਕਾਸ਼, ਅਰ ਸਭ੍ਯਤਾ ਨੂੰ ਨਾ ਦੂਰ ਕਰਕੇ ਉਮਾਹ ਦੇਣ ਵਾਲੇ ਉਛਾਲੇ ਸਤਿਸੰਗ ਦੇ ਰੰਗ ਵਾਲੇ ਕਾਇਮ ਰਹਿਣੇ ਚਾਹੀਏ। ਮਹੱਲੇ ਦਾ ਚੜ੍ਹਨਾ ਤਾਂ ਸਿੰਘ ਸਭਾ ਦੇ ਉੱਦਮ ਨਾਲ ਮੁੜ ਜਾਰੀ ਹੋ ਪਿਆ ਹੈ ਤੇ ਮਹੱਲੇ ਵਾਲੇ ਦਿਨ ਮੰਦਰ ਦੇ ਇਸ਼ਨਾਨ ਦਾ ਰਿਵਾਜ ਬੀ ਸੰਗਤ ਤੇ ਜ਼ੋਰ ਦੇਣ ਕਰਕੇ ਫਿਰ ਖੁੱਲ੍ਹ ਪਿਆ ਹੈ।",
          Rut 3,27,ਭਾਈ ਨੰਦਲਾਲ ਜੀ। ਹੋਲੀ,ਚੌਪਈ,ਧਰਿ ‘ਦਿਵਾਨ ਗੋਯਾ’ ਤਿਸੁ ਨਾਮ,16,,,,
          Rut 3,27,ਭਾਈ ਨੰਦਲਾਲ ਜੀ। ਹੋਲੀ,ਚੌਪਈ,ਪੁਨ ਸੰਗਤਿ ਪਰ ਦ੍ਰਿਸ਼ਟਿ ਚਲਾਈ,16,,,,
          Rut 3,27,ਭਾਈ ਨੰਦਲਾਲ ਜੀ। ਹੋਲੀ,ਚੌਪਈ,ਅਰਣ ਬਰਣ ਇਕ ਸਮ ਸਮੁਦਾਈ,16,,,,
        ROWS
      end

      it 'creates an `external_pauri` with `bhai_vir_singh_footnote`' do
        GranthImporter.new(csv_data).execute

        book = Book.find_by(:en_title => 'Rut 3')
        chapter = Chapter.find_by(:book => book, :number => 27)
        pauri = chapter.pauris.find_by(:number => 16)
        external_pauri = ExternalPauri.find_by(:pauri => pauri)

        expect(external_pauri.original_content).to include('ਜਥਾ ਯਾਂ ਹੋਲੀ ਗੁਲੇ')
        expect(external_pauri.content).to include('ਜਥਾ ਯਾਂ ਹੋਲੀ ਗੁਲੇ')
        expect(external_pauri.bhai_vir_singh_footnote).to include('ਫਿਰ ਖੁੱਲ੍ਹ ਪਿਆ ਹੈ')
      end
    end
  end
end
