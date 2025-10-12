class CarDescription < ApplicationRecord
  belongs_to :product

  validates :seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :transmission, presence: true, inclusion: { in: %w[manual automatic] }
  validates :car_type, presence: true, inclusion: { in: %w[petrol diesel electric hybrid] }
end
