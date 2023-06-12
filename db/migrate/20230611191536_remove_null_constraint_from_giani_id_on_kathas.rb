# frozen_string_literal: true

class RemoveNullConstraintFromGianiIdOnKathas < ActiveRecord::Migration[7.0]
  def change
    change_column_null :kathas, :giani_id, true
  end
end
