class CreateChhandTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :chhand_types do |t|
      t.string :chhand_name
      
      t.timestamps
    end
  end
end
