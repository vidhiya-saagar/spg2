# frozen_string_literal: true

class AddSequenceToChhand < ActiveRecord::Migration[7.0]
  def up
    ##
    # NOTE:
    # We forgot to add `sequence` to chhands table.
    # Luckily, none of the developers have any data in the `chhands` table.
    # Thus, we have to `.destroy_all` the data in the `chhands` table.
    #  BONUS NOTE:
    # The reason we aren't doing TRUNCATE is because we also want the destroy
    # to cascade to the relevant tables, such as `pauris`, etc.
    ##

    Chhand.destroy_all

    add_column :chhands, :sequence, :integer, :null => false
    add_index :chhands, [:chapter_id, :sequence], :unique => true
  end

  def down
    remove_index :chhands, [:chapter_id, :sequence]
    remove_column :chhands, :sequence
  end
end
