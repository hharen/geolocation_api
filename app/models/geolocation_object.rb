class GeolocationObject < ApplicationRecord
  validates :ip, presence: true, uniqueness: true
end