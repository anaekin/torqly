class Product < ApplicationRecord
  belongs_to :product_type
  has_one :description, dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  has_many :bookings
  accepts_nested_attributes_for :description

  default_scope { includes(:product_type, :description) }

  validates :title, :summary, :price, :brand, :model, :year, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1970, less_than_or_equal_to: Date.current.year + 1 }
  validates :enabled, inclusion: { in: [ true, false ] }
  validates :product_type, presence: true
  validates :description, presence: true

  scope :enabled, -> { where(enabled: true) }

  after_initialize :initialize_description, if: :new_record?

  before_validation :update_product_type, if: :new_record?

  def product_type_slug = product_type&.slug
  def car? = product_type_slug == ProductType.car_slug
  def motorcycle? = product_type_slug == ProductType.motorcycle_slug
  def scooter? = product_type_slug == ProductType.scooter_slug

  def update_product_type
    description.product_type = product_type
    description.type =
      case product_type.slug
      when ProductType.car_slug then "CarDescription"
      when ProductType.motorcycle_slug then "MotorcycleDescription"
      when ProductType.scooter_slug then "ScooterDescription"
      else "Description"
      end
  end

  private

  def initialize_description
    return if description

    case product_type&.slug || ProductType.find_by(id: product_type_id)&.slug
    when ProductType.car_slug
      build_description(type: "CarDescription")
    when ProductType.motorcycle_slug
      build_description(type: "MotorcycleDescription")
    when ProductType.scooter_slug
      build_description(type: "ScooterDescription")
    end
  end
end
