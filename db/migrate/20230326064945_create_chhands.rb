class CreateChhands < ActiveRecord::Migration[7.0]
  def change
    create_table :chhands do |t|
      t.references :chapter, :foreign_key => true, :null => false
      t.string :chhand_type
      t.string :en_chhand_type
      t.references :chhand_type, :foreign_key => true, :null => false
      t.string :vaak
      
      t.timestamps
    end
  end
end
