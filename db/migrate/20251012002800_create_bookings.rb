class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.date    :start_date, null: false
      t.date    :end_date, null: false
      t.integer :booked_price, null: false
      t.string  :license_number, null: false
      t.string  :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :bookings, [ :start_date, :end_date ]
    add_check_constraint :bookings, "end_date >= start_date", name: "bookings_valid_range"
    add_check_constraint :bookings,
      "status IN ('pending','confirmed','cancelled','completed')",
      name: "bookings_status_check"
  end
end
