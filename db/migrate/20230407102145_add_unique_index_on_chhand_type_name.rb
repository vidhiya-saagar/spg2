# frozen_string_literal: true

class AddUniqueIndexOnChhandTypeName < ActiveRecord::Migration[7.0]
  def change
    add_index :chhand_types, :name, :unique => true
  end
end
