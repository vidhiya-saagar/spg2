# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tuk do
  let(:chapter) { create(:chapter) }
  let(:pauri) { create(:pauri, :chapter => chapter) }

  describe 'validations' do
    context 'when given valid attributes' do
      it 'saves' do
        tuk = Tuk.new(:sequence => 1, :content => 'Valid content', :chapter => chapter, :pauri => pauri)
        expect(tuk).to be_valid
      end
    end

    context 'when given invalid attributes' do
      it 'does not save without a `sequence`' do
        tuk = Tuk.new(:content => 'Valid content', :chapter => chapter, :pauri => pauri)
        expect(tuk).not_to be_valid
      end

      it 'does not save without a `content`' do
        tuk = Tuk.new(:sequence => 1, :chapter => chapter, :pauri => pauri)
        expect(tuk).not_to be_valid
      end

      it 'does not save without a `chapter`' do
        tuk = Tuk.new(:sequence => 1, :content => 'Valid content', :pauri => pauri)
        expect(tuk).not_to be_valid
      end

      it 'does not save without a `pauri`' do
        tuk = Tuk.new(:sequence => 1, :content => 'Valid content', :chapter => chapter)
        expect(tuk).not_to be_valid
      end

      it 'does not save with the same `sequence` within the same `pauri`' do
        create(:tuk, :sequence => 1, :content => 'Existing content', :chapter => chapter, :pauri => pauri)
        new_tuk = Tuk.new(:sequence => 1, :content => 'New content', :chapter => chapter, :pauri => pauri)
        expect(new_tuk).not_to be_valid
      end
    end

    describe 'associations' do
      let!(:tuk) { create(:tuk, :chapter => chapter, :pauri => pauri) }
      let!(:tuk_translation) { create(:tuk_translation, :tuk => tuk) }

      it 'destroys the associated `TukTranslation` upon `Tuk` destroy', :aggregate_failures do
        tuk.destroy!

        expect(TukTranslation.find_by(:id => tuk_translation.id)).to be_nil
      end
    end
  end

  describe 'callbacks' do
    context 'when saving' do
      it 'removes extra white space in `content`' do
        tuk = Tuk.create!(:sequence => 1, :content => '  Extra  whitespace  ', :chapter => chapter, :pauri => pauri)
        expect(tuk.reload.content).to eq('Extra whitespace')
      end

      it 'removes, superscripts, and unwanted symbols from `content`' do
        tuk = Tuk.create!(:sequence => 1, :content => 'Content with †⚑ and `~!@#$%^&*()_|+-=?;:\'",.<>‘’{} symbols', :chapter => chapter, :pauri => pauri)
        expect(tuk.reload.content).to eq('Content with and symbols')
      end
    end
  end
end
