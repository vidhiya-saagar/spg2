# frozen_string_literal: true

class CreatePauris < ActiveRecord::Migration[7.0]
  def change
    create_table :pauris do |t|
      t.integer :number, :null => false
      t.references :chapter, :foreign_key => true, :null => false
      t.references :chhand, :foreign_key => true, :null => false

      t.timestamps
    end
  end
end
