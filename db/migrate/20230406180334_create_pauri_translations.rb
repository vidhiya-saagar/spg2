# frozen_string_literal: true

class CreatePauriTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :pauri_translations do |t|
      t.string :en_translation
      t.string :en_translator
      t.references :pauri, :foreign_key => true, :null => false

      t.timestamps
    end
  end
end
