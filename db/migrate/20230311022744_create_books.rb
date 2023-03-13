# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.integer :sequence, :null => false
      t.string :title, :null => false
      t.string :en_title
      t.string :en_short_summary
      t.text :en_synopsis
      t.text :artwork_url

      t.timestamps
    end
  end
end
