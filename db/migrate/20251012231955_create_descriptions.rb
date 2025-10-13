class CreateDescriptions < ActiveRecord::Migration[8.0]
  def up
    create_table :descriptions do |t| # Create new table
      t.references :product, null: false, foreign_key: true, index: true
      t.references :product_type, null: false, foreign_key: true, index: true
      t.string :type, null: false # Required for STI

      t.integer :seats, default: 4
      t.string :transmission, default: "manual"
      t.string :car_type, default: "petrol"

      t.integer :engine_cc
      t.integer :engine_hp
      t.integer :engine_nm

      t.integer :range_km
      t.boolean :helmet_included
      t.integer :seat_storage

      t.timestamps
    end

    drop_table :car_descriptions, if_exists: true
    drop_table :motorcycle_descriptions, if_exists: true
    drop_table :scooter_descriptions, if_exists: true
  end

  down do
    create_table :car_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :seats, default: 4
      t.string :transmission, default: "manual"
      t.string :car_type, default: "petrol"

      t.timestamps
    end

    create_table :motorcycle_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :engine_cc, null: false
      t.integer :engine_hp, null: false
      t.integer :engine_nm, null: false

      t.timestamps
    end

    create_table :scooter_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :range_km
      t.boolean :helmet_included
      t.integer :seat_storage

      t.timestamps
    end

    drop_table :descriptions
  end
end
