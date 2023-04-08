# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chhand do
  let(:chhand_type) { create(:chhand_type) }
  let(:chapter) { create(:chapter) }

  describe 'validations' do
    context 'when given valid attributes' do
      it 'saves the `Chhand`' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => chapter, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).to be_valid
      end

      it 'saves the `Chhand` without `vaak`' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => chapter, :sequence => 1)
        expect(chhand).to be_valid
      end
    end

    context 'when given invalid attributes' do
      it 'does not save the `Chhand` without a `chhand_type`' do
        chhand = Chhand.new(:chapter => chapter, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end

      it 'does not save the `Chhand` without a `chapter`' do
        chhand = Chhand.new(:chhand_type => chhand_type, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end

      it 'does not save the `Chhand` with a non-existent `chhand_type_id`' do
        chhand = Chhand.new(:chhand_type_id => 999, :chapter => chapter, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end

      it 'does not save the `Chhand` with a non-existent `chapter_id`' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter_id => 999, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end

      it 'does not save the `Chhand` with a null `chhand_type`' do
        chhand = Chhand.new(:chhand_type => nil, :chapter => chapter, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end

      it 'does not save the `Chhand` with a null `chapter`' do
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => nil, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end

      it 'does not save the `Chhand` with a duplicate `sequence` within the same `chapter`' do
        create(:chhand, :chapter => chapter, :sequence => 1)
        chhand = Chhand.new(:chhand_type => chhand_type, :chapter => chapter, :vaak => 'Example vaak', :sequence => 1)
        expect(chhand).not_to be_valid
      end
    end
  end
end
