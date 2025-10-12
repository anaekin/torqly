class Transaction < ApplicationRecord
  belongs_to :booking

  enum :status, { pending: "pending", succeeded: "succeeded", failed: "failed", refunded: "refunded" }
  enum :payment_type, { card: "card", bank_transfer: "bank_transfer", cash: "cash", other: "other" }

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
