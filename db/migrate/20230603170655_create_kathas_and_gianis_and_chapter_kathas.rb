# frozen_string_literal: true

class CreateKathasAndGianisAndChapterKathas < ActiveRecord::Migration[7.0]
  def up
    create_table :gianis do |t|
      t.string :name, :null => false
      t.string :artwork_url

      t.timestamps
    end

    create_table :kathas do |t|
      t.references :giani, :null => false, :foreign_key => true
      t.string :title
      t.string :public_url
      t.string :soundcloud_url
      t.integer :year

      t.timestamps
    end

    create_table :chapter_kathas do |t|
      t.references :chapter, :null => false, :foreign_key => true
      t.references :katha, :null => false, :foreign_key => true

      t.timestamps
    end

    # Seeding Gianis
    Giani.create!([
      { :id => 1, :name => 'Giani Harbhajan Singh Dhudike' },
      { :id => 2, :name => 'Nihang Giani Sher Singh Ambala' },
      { :id => 3, :name => 'Sant Giani Inderjit Singh Raqbewale' },
      { :id => 4, :name => 'Bhai Sukha Singh UK' },
      { :id => 5, :name => 'The Suraj Podcast' }
    ])
  end

  def down
    drop_table :gianis
    drop_table :kathas
    drop_table :chapter_kathas
  end
end
