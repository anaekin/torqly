class AddNumDaysToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :num_days, :integer, null: false
  end
end
