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
  end

  def down
    drop_table :gianis
    drop_table :kathas
    drop_table :chapter_kathas
  end
end
