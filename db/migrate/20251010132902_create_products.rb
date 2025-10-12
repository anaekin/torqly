class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :product_type, null: false, foreign_key: true
      t.string :title, null: false
      t.text :summary, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :brand, null: false
      t.string :model, null: false
      t.integer :year, null: false
      t.string :image_url
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
