class CreateCarDescriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :car_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :seats, default: 4
      t.string :transmission, default: "Manual"
      t.string :fuel_type, default: "Petrol"

      t.timestamps
    end
  end
end
