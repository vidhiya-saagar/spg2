# frozen_string_literal: true

class CreatePauriFootnotes < ActiveRecord::Migration[7.0]
  def change
    create_table :pauri_footnotes do |t|
      t.references :pauri, :foreign_key => true, :null => false, :index => true
      t.text :bhai_vir_singh_footnote
      t.string :contentful_entry_id, :index => { :unique => true }

      t.timestamps
    end
  end
end
