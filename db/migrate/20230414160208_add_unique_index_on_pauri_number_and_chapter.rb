# frozen_string_literal: true

class AddUniqueIndexOnPauriNumberAndChapter < ActiveRecord::Migration[7.0]
  def change
    add_index :pauris, [:number, :chapter_id], :unique => true
  end
end
