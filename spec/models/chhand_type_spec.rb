# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChhandType do
  describe 'validations' do
    it 'saves a valid `chhand_type` when we pass in the name that is written in Gurmukhi' do
      chhand_type = build(:chhand_type, :name => 'ਪੰਚਮਿ ਪਦ', :en_name => 'Fifth Stanza')
      expect(chhand_type.save).to be true
    end

    it 'does not save a `chhand_type` if we pass in an invalid, non-existent value for `name`' do
      chhand_type = build(:chhand_type, :name => '', :en_name => 'Invalid')
      expect(chhand_type.save).to be false
    end

    it 'does not save a `chhand_type` if we pass in a null value for `name`' do
      chhand_type = build(:chhand_type, :name => nil, :en_name => 'Invalid')
      expect(chhand_type.save).to be false
    end

    it 'deletes the associated `chhands` when `chhand_type` is destroyed' do
      chhand_type = create(:chhand_type)
      create(:chhand, :chhand_type => chhand_type)
      create(:chhand, :chhand_type => chhand_type)
      expect { chhand_type.destroy }.to change { Chhand.count }.by(-2)
    end

    it 'does not save a `chhand_type` if the `name` already exists' do
      create(:chhand_type, :name => 'ਪੰਚਮਿ ਪਦ', :en_name => 'Fifth Stanza')
      duplicate_chhand_type = build(:chhand_type, :name => 'ਪੰਚਮਿ ਪਦ', :en_name => 'Another Fifth Stanza')
      expect(duplicate_chhand_type.save).to be false
    end
  end
end
