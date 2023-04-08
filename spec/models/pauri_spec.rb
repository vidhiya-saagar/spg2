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
    end
  end
end
