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

      it 'creates the first tuk with correct sequence, content, and chapter' do
        tuk1 = Tuk.find_by(:sequence => 1, :pauri => pauri)
        expect(tuk1).not_to be_nil
        expect(tuk1.content).to eq('ਏਕੁੰਕਾਰਾ ਸਤਿਗੁਰੂ ਤਿਹਿ ਪ੍ਰਸਾਦਿ ਸਚੁ ਹੋਇ')
        expect(tuk1.pauri.chhand.chapter.number).to eq(1)
      end

      it 'creates the second tuk with correct sequence, content, and chapter' do
        tuk2 = Tuk.find_by(:sequence => 2, :pauri => pauri)
        expect(tuk2).not_to be_nil
        expect(tuk2.content).to eq('ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫਤੇ ਵਿਘਨ ਵਿਨਾਸ਼ਨ ਸੋਇ')
        expect(tuk2.pauri.chhand.chapter.number).to eq(1)
      end
    end
  end
end
