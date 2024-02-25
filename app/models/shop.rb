class Shop < ApplicationRecord
    geocoded_by :address
    after_validation :geocode

    belongs_to :user

    validates :name, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :evaluation, presence: true

end
