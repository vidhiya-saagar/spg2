# frozen_string_literal: true

class Pauri < ApplicationRecord
  belongs_to :chapter
  has_one :translation, :class_name => 'PauriTranslation', :dependent => :destroy
end
