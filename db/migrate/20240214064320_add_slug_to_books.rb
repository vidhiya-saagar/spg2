# frozen_string_literal: true

class AddSlugToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :slug, :string
    add_index :books, :slug, :unique => true

    slug_mappings = [
      { :id => 1, :slug => 'nanak-prakash-purbardh' },
      { :id => 2, :slug => 'nanak-prakash-utrardh' },
      { :id => 3, :slug => 'raas-1' },
      { :id => 4, :slug => 'raas-2' },
      { :id => 5, :slug => 'raas-3' },
      { :id => 6, :slug => 'raas-4' },
      { :id => 7, :slug => 'raas-5' },
      { :id => 8, :slug => 'raas-6' },
      { :id => 9, :slug => 'raas-7' },
      { :id => 10, :slug => 'raas-8' },
      { :id => 11, :slug => 'raas-9' },
      { :id => 12, :slug => 'raas-10' },
      { :id => 13, :slug => 'raas-11' },
      { :id => 14, :slug => 'raas-12' },
      { :id => 15, :slug => 'rut-1' },
      { :id => 16, :slug => 'rut-2' },
      { :id => 17, :slug => 'rut-3' },
      { :id => 18, :slug => 'rut-4' },
      { :id => 19, :slug => 'rut-5' },
      { :id => 20, :slug => 'rut-6' },
      { :id => 21, :slug => 'ayaan-1' },
      { :id => 22, :slug => 'ayaan-2' }
    ]

    reversible do |dir|
      dir.up do
        slug_mappings.each do |mapping|
          Book.find_by(:id => mapping[:id])&.update(:slug => mapping[:slug])
        end
      end
    end
  end
end
