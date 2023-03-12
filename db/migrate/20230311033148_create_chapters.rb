class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.references :book, :foreign_key => true, :null => false
      t.integer :number, :null => false
      t.string :title, :null => false
      t.string :en_title
      t.string :en_short_summary
      t.text :en_long_summary
      t.string :samapati
      t.string :en_samapati
      t.text :artwork_url

      t.timestamps
    end


    add_index :chapters, [:book_id, :number], :unique => true
  end
end
