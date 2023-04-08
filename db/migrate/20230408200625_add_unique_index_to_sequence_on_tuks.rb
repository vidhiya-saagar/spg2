# frozen_string_literal: true

class AddUniqueIndexToSequenceOnTuks < ActiveRecord::Migration[7.0]
  def change
    add_index :tuks, [:sequence, :pauri_id], :unique => true
  end
end
