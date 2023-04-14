# frozen_string_literal: true

class CreateExternalPauris < ActiveRecord::Migration[7.0]
  def change
    create_table :external_pauris do |t|
      t.references :pauri, :foreign_key => true, :null => false
      t.text :content, :null => false
      t.text :original_content
      t.text :bhai_vir_singh_footnote
      t.timestamps
    end
  end
end
