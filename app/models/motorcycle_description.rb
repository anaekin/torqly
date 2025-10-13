class MotorcycleDescription < Description
  validates :engine_cc, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :engine_hp, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :engine_nm, presence: true, numericality: { only_integer: true, greater_than: 0 }


  def motorcycle_attributes
    {
      engine_cc: engine_cc,
      engine_hp: engine_hp,
      engine_nm: engine_nm
    }
  end
end
