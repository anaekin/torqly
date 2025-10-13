class ScooterDescription < Description
  validates :range_km, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :helmet_included, inclusion: { in: [ true, false ] }
  validates :seat_storage, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def scooter_attributes
    {
      range_km: range_km,
      helmet_included: helmet_included,
      seat_storage: seat_storage
    }
  end
end
