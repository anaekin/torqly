class ChangeSeatStorageToIntegerInScooterDescriptions < ActiveRecord::Migration[8.0]
  def change
    change_column :scooter_descriptions,
                  :seat_storage,
                  :integer,
                  using: "seat_storage::integer"
  end
end
