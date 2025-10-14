class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :payments, dependent: :destroy

  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled", completed: "completed" }

  validates :start_date, :end_date, :license_number, :booked_price, :product_id, :user_id, :num_days, presence: true
  validates :booked_price, numericality: { greater_than_or_equal_to: 0 }

  validate :valid_start_date, :valid_end_date, if: :new_record?

  after_initialize :set_default_values, if: :new_record?

  attribute :status, default: "pending"

  def cancelled?
    status == "cancelled"
  end

  def completed?
    status == "completed"
  end

  def confirmed?
    status == "confirmed"
  end

  def pending?
    status == "pending"
  end

  private

  def set_default_values
    self.num_days = (end_date - start_date).to_i + 1
    self.booked_price = product.price if self.booked_price.nil?
  end

  def valid_start_date
    return unless start_date
    if start_date < Date.today
      errors.add(:start_date, "should be today or later")
    end
  end

  def valid_end_date
    return unless start_date && end_date
    if end_date < start_date
      errors.add(:end_date, "should be after or equal to start date")
    end
  end
end
