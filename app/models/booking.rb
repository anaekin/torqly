class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :transactions, dependent: :destroy

  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled", completed: "completed" }

  validates :start_date, :end_date, :license_number, :booked_price, presence: true
  validates :booked_price, numericality: { greater_than_or_equal_to: 0 }
end
