class Payment < ApplicationRecord
  belongs_to :booking

  enum :status, { pending: "pending", succeeded: "succeeded", failed: "failed", refunded: "refunded" }
  enum :payment_type, { card: "card", bank_transfer: "bank_transfer", cash: "cash", other: "other" }

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  attribute :payment_type, default: nil

  scope :succeeded, -> { where(status: "succeeded") }

  def pending?
    status == "pending"
  end

  def succeeded?
    status == "succeeded"
  end

  def failed?
    status == "failed"
  end

  def refunded?
    status == "refunded"
  end

  def refund!
    update!(status: "refunded")
  end
end
