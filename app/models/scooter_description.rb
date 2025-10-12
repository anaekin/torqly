class ScooterDescription < ApplicationRecord
  belongs_to :product

  validates :range_km, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :helmet_included, inclusion: { in: [ true, false ] }
  validates :seat_storage, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
