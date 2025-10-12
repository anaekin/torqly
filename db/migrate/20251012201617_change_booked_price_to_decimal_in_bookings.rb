class ChangeBookedPriceToDecimalInBookings < ActiveRecord::Migration[8.0]
  def change
    change_column :bookings, :booked_price, :decimal, precision: 10, scale: 2
  end
end
