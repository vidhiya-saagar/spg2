# frozen_string_literal: true

class CreateTukTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :tuk_translations do |t|
      t.references :tuk, :foreign_key => true, :null => false, :index => true
      t.string :en_translation
      t.string :en_translator

      t.timestamps
    end
  end
end
