# frozen_string_literal: true

class Chhand < ApplicationRecord
  belongs_to :chhand_type
  belongs_to :chapter
end
