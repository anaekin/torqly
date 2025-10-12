class Product < ApplicationRecord
  belongs_to :product_type

  validates :title, :summary, :price, :brand, :model, :year, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1970, less_than_or_equal_to: Date.current.year + 1 }
  validates :enabled, inclusion: { in: [ true, false ] }
  validates :product_type, presence: true
  validate :vehicle_description_presence

  has_one_attached :image, dependent: :purge_later

  has_one :car_description, dependent: :destroy
  has_one :motorcycle_description, dependent: :destroy
  has_one :scooter_description, dependent: :destroy

  accepts_nested_attributes_for :car_description, :motorcycle_description, :scooter_description

  def product_type_slug = product_type&.slug
  def car?        = product_type_slug == ProductType.car_slug
  def motorcycle? = product_type_slug == ProductType.motorcycle_slug
  def scooter?    = product_type_slug == ProductType.scooter_slug

  scope :enabled, -> { where(enabled: true) }

  def self.load_details(id)
    includes(:product_type, :car_description, :motorcycle_description, :scooter_description)
      .find(id)
  end

  private

  def vehicle_description_presence
    if car?
      errors.add(:car_description, "must be present for car products") unless car_description.present?
    elsif motorcycle?
      errors.add(:motorcycle_description, "must be present for motorcycle products") unless motorcycle_description.present?
    elsif scooter?
      errors.add(:scooter_description, "must be present for scooter products") unless scooter_description.present?
    else
      errors.add(:product_type, "is invalid")
    end
  end

  def vehicle_description
    return car_description if car?
    return motorcycle_description if motorcycle?
    return scooter_description if scooter?
    nil
  end
end
