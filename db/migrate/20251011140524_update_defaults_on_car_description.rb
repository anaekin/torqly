class UpdateDefaultsOnCarDescription < ActiveRecord::Migration[8.0]
  def change
    change_column_default :car_descriptions, :transmission, from: "Manual", to: "manual"
    change_column_default :car_descriptions, :car_type, from: "Petrol", to: "petrol"
  end
end
