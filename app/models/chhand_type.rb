class ChhandType < ApplicationRecord
    has_many :chhands, :dependent => :destroy
end
