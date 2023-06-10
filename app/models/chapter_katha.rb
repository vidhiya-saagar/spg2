# frozen_string_literal: true

class ChapterKatha < ApplicationRecord
  belongs_to :katha
  belongs_to :chapter
end
