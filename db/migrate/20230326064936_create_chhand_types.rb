# frozen_string_literal: true

class CreateChhandTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :chhand_types do |t|
      t.string :name, :null => false
      t.string :en_name

      t.timestamps
    end
  end
end
