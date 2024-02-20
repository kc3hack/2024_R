class Shop < ApplicationRecord
    geocoded_by :address
    after_validation :geocode

    validates :name, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :evaluation, presence: true

end
