class MotorcycleDescription < ApplicationRecord
  belongs_to :product

  validates :engine_cc, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :engine_hp, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :engine_nm, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
