# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chhand do
  let(:chhand_type) { create(:chhand_type) }
  let(:chapter) { create(:chapter) }

  describe 'validations' do
    context 'when given valid attributes' do
      it 'saves the chhand' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => chapter, :vaak => 'Example vaak')
        expect(chhand).to be_valid
      end

      it 'saves the chhand without vaak' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => chapter)
        expect(chhand).to be_valid
      end
    end

    context 'when given invalid attributes' do
      it 'does not save the chhand without a chhand_type' do
        chhand = Chhand.new(:chapter => chapter, :vaak => 'Example vaak')
        expect(chhand).not_to be_valid
      end

      it 'does not save the chhand without a chapter' do
        chhand = Chhand.new(:chhand_type => chhand_type, :vaak => 'Example vaak')
        expect(chhand).not_to be_valid
      end

      it 'does not save the chhand with a non-existent chhand_type' do
        chhand = Chhand.new(:chhand_type_id => 999, :chapter => chapter, :vaak => 'Example vaak')
        expect(chhand).not_to be_valid
      end

      it 'does not save the chhand with a non-existent chapter' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter_id => 999, :vaak => 'Example vaak')
        expect(chhand).not_to be_valid
      end

      it 'does not save the chhand with a null chhand_type' do
        chhand = Chhand.new(:chhand_type => nil, :chapter => chapter, :vaak => 'Example vaak')
        expect(chhand).not_to be_valid
      end

      it 'does not save the chhand with a null chapter' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => nil, :vaak => 'Example vaak')
        expect(chhand).not_to be_valid
      end
    end
  end
end
