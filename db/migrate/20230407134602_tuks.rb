# frozen_string_literal: true

class Tuks < ActiveRecord::Migration[7.0]
  def change
    create_table :tuks do |t|
      t.references :chapter, :foreign_key => true, :null => false, :index => true
      t.integer :sequence, :null => false
      t.string :content, :null => false
      t.string :original_content

      t.timestamps
    end
  end
end
