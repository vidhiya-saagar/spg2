# frozen_string_literal: true

class CreateTukFootnotes < ActiveRecord::Migration[7.0]
  def change
    create_table :tuk_footnotes do |t|
      t.references :tuk, :foreign_key => true, :null => false, :index => true
      t.text :bhai_vir_singh_footnote
      t.string :contentful_entry_id, :index => { :unique => true }
      t.timestamps
    end
  end
end
