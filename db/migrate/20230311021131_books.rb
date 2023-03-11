class Books < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.integer :sequence
      t.string :title
      t.string :en_title
      t.string :en_short_summary
      t.text :en_synopsis
      t.text :artwork_url

      t.timestamps
    end
  end
end
