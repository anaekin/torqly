class ProductType < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  SLUGS = {
    car: "car",
    motorcycle: "motorcycle",
    scooter: "scooter"
  }.freeze

  def self.car_slug        = SLUGS[:car]
  def self.motorcycle_slug = SLUGS[:motorcycle]
  def self.scooter_slug    = SLUGS[:scooter]
end
