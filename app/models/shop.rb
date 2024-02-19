class Shop < ApplicationRecord

    validates :name, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :evaluation, presence: true

end
