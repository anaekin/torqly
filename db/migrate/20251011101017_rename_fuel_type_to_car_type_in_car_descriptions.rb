class RenameFuelTypeToCarTypeInCarDescriptions < ActiveRecord::Migration[8.0]
  def change
    rename_column(:car_descriptions, :fuel_type, :car_type)
  end
end
