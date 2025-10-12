class CreateMotorcycleDescriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :motorcycle_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :engine_cc, null: false
      t.integer :engine_hp, null: false
      t.integer :engine_nm, null: false

      t.timestamps
    end
  end
end
