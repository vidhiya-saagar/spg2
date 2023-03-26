class CreateChhands < ActiveRecord::Migration[7.0]
  def change
    create_table :chhands do |t|
      t.references :chapter, :foreign_key => true, :null => false
      t.references :chhand_type, :foreign_key => true, :null => false
      t.string :vaak
      
      t.timestamps
    end
  end
end
