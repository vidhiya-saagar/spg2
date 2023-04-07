# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pauri do
  describe 'validations' do
    let!(:chapter) { create(:chapter) }
    let!(:chhand) { create(:chhand, :chapter => chapter) }

    it 'is valid with a chapter, chhand, and number' do
      pauri = build(:pauri, :chapter => chapter, :chhand => chhand)
      expect(pauri).to be_valid
    end

    it 'is not valid without a chapter' do
      pauri = build(:pauri, :chhand => chhand)
      expect(pauri).not_to be_valid
    end

    it 'is not valid without a chhand' do
      pauri = build(:pauri, :chapter => chapter)
      expect(pauri).not_to be_valid
    end

    it 'is not valid without a number' do
      pauri = build(:pauri, :chapter => chapter, :chhand => chhand, :number => nil)
      expect(pauri).not_to be_valid
    end

    it 'is not valid with a duplicate number in the same chapter' do
      pauri = create(:pauri, :chapter => chapter, :chhand => chhand)
      duplicate_pauri = build(:pauri, :chapter => chapter, :chhand => chhand, :number => pauri.number)
      expect(duplicate_pauri).not_to be_valid
    end
  end

  describe 'associations' do
    ##
    # `let!` is a RSpec helper method that defines a memoized helper method.
    # When the helper method is called, it will lazily create the object only when it is first needed.
    # The `!` version of let ensures that the object is created immediately, as opposed to lazily.
    ##
    let!(:pauri) { create(:pauri) }

    it 'destroys pauri_translations when destroyed' do
      create(:pauri_translation, :pauri => pauri)
      expect { pauri.destroy }.to change { PauriTranslation.count }.by(-1)
    end

    it 'destroys tuks when destroyed' do
      create(:tuk, :pauri => pauri)
      expect { pauri.destroy }.to change { Tuk.count }.by(-1)
    end
  end
end
