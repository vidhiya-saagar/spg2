# frozen_string_literal: true

class Tuk < ApplicationRecord
  belongs_to :chapter
  belongs_to :pauri
  has_one :translation, :class_name => 'TukTranslation', :dependent => :destroy
end
