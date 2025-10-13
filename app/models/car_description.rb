class CarDescription < Description
  validates :seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :transmission, presence: true, inclusion: { in: %w[manual automatic] }
  validates :car_type, presence: true, inclusion: { in: %w[petrol diesel electric hybrid] }

  def car_attributes
    {
      seats: seats,
      transmission: transmission,
      car_type: car_type
    }
  end
end
