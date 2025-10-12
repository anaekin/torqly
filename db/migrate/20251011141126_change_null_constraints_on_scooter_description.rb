class ChangeNullConstraintsOnScooterDescription < ActiveRecord::Migration[8.0]
  def change
    change_column_null(:scooter_descriptions, :range_km, false)
    change_column_null(:scooter_descriptions, :helmet_included, false)
    change_column_null(:scooter_descriptions, :seat_storage, false)
  end
end
