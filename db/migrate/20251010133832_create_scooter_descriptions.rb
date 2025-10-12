class CreateScooterDescriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :scooter_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :range_km
      t.boolean :helmet_included
      t.boolean :seat_storage

      t.timestamps
    end
  end
end
