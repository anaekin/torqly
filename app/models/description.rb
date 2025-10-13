class Description < ApplicationRecord
  belongs_to :product
  belongs_to :product_type
  validates :product_type_id, presence: true
end
