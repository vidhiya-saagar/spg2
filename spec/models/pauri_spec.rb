# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pauri do
  let(:chapter) { create(:chapter) }
  let(:chhand) { create(:chhand) }

  describe 'validations' do
    context 'when given valid attributes' do
      it 'saves' do
        pauri = Pauri.new(:number => 1, :chapter => chapter, :chhand => chhand)
        expect(pauri).to be_valid
      end
    end

    context 'when given invalid attributes' do
      it 'does not save without a `number`' do
        pauri = Pauri.new(:chapter => chapter, :chhand => chhand)
        expect(pauri).not_to be_valid
      end

      it 'does not save without a `chapter`' do
        pauri = Pauri.new(:number => 1, :chhand => chhand)
        expect(pauri).not_to be_valid
      end

      it 'does not save without a `chhand`' do
        pauri = Pauri.new(:number => 1, :chapter => chapter)
        expect(pauri).not_to be_valid
      end

      it 'does not save with a non-existent `chapter_id`' do
        pauri = Pauri.new(:number => 1, :chapter_id => 999, :chhand => chhand)
        expect(pauri).not_to be_valid
      end

      it 'does not save with a non-existent `chhand_id`' do
        pauri = Pauri.new(:number => 1, :chapter => chapter, :chhand_id => 999)
        expect(pauri).not_to be_valid
      end

      it 'does not save with a null `chapter`' do
        pauri = Pauri.new(:number => 1, :chapter => nil, :chhand => chhand)
        expect(pauri).not_to be_valid
      end

      it 'does not save with a null `chhand`' do
        pauri = Pauri.new(:number => 1, :chapter => chapter, :chhand => nil)
        expect(pauri).not_to be_valid
      end

      it 'does not save if the pauri number is 0' do
        pauri = Pauri.new(:number => 0, :chapter => chapter, :chhand => chhand)
        expect(pauri).not_to be_valid
      end

      it 'does not save if there is already a pauri with the same number that belongs to the same chapter' do
        existing_pauri = create(:pauri, :number => 1, :chapter => chapter, :chhand => chhand)
        new_pauri = Pauri.new(:number => 1, :chapter => chapter, :chhand => chhand)
        expect(new_pauri).not_to be_valid
      end
    end

    describe 'associations' do
      let!(:pauri) { create(:pauri, :chapter => chapter, :chhand => chhand) }
      let!(:pauri_translation) { create(:pauri_translation, :pauri => pauri) }
      let!(:tuk) { create(:tuk, :chapter => chapter, :pauri => pauri) }
      let!(:tuk_translation) { create(:tuk_translation, :tuk => tuk) }

      it 'destroys the associated PauriTranslations, Tuks, and TukTranslations when destroyed' do
        pauri.destroy!

        expect(PauriTranslation.find_by(:id => pauri_translation.id)).to be_nil
        expect(Tuk.find_by(:id => tuk.id)).to be_nil
        expect(TukTranslation.find_by(:id => tuk_translation.id)).to be_nil
      end
    end
  end

  describe 'updates' do
    let!(:pauri) { create(:pauri, :chapter => chapter, :chhand => chhand) }
    let!(:other_pauri) { create(:pauri, :number => 2, :chapter => chapter, :chhand => chhand) }

    it 'updating a valid pauri to giving it a null `chapter` should fail' do
      pauri.chapter = nil
      expect(pauri).not_to be_valid
    end

    it 'updating a valid pauri to giving it a null `chhand` should fail' do
      pauri.chhand = nil
      expect(pauri).not_to be_valid
    end

    it "updating a valid pauri's number to another number that already has that number within the same chapter should fail" do
      pauri.number = other_pauri.number
      expect(pauri).not_to be_valid
    end
  end
end
