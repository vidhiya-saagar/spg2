# frozen_string_literal: true

class PauriFootnote < ApplicationRecord
  belongs_to :pauri
  validates :contentful_entry_id, :uniqueness => true
end
