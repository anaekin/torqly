class User < ApplicationRecord
  has_secure_password
  has_many :bookings

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, allow_blank: true
end
